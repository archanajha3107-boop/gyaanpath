import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/content_provider.dart';
import '../../models/question_model.dart';
import '../../models/solution_model.dart';

class SolutionScreen extends StatefulWidget {
  final int chapterId;
  const SolutionScreen({super.key, required this.chapterId});

  @override
  State<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends State<SolutionScreen> {
  String _selectedExercise = 'All';
  List<String> _exercises  = ['All'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ContentProvider>()
        .loadQuestions(widget.chapterId);
      _buildExerciseList();
    });
  }

  void _buildExerciseList() {
    final questions = context.read<ContentProvider>().questions;
    final names = questions
      .map((q) => q.exerciseName)
      .toSet()
      .toList();
    setState(() {
      _exercises = ['All', ...names];
    });
  }

  List<QuestionModel> _filtered(List<QuestionModel> all) {
    if (_selectedExercise == 'All') return all;
    return all.where((q) =>
      q.exerciseName == _selectedExercise
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final content = context.watch<ContentProvider>();
    final filtered = _filtered(content.questions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solutions'),
      ),
      body: content.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Exercise filter tabs
              if (_exercises.length > 1)
                _ExerciseTabBar(
                  exercises: _exercises,
                  selected:  _selectedExercise,
                  onSelect: (e) =>
                    setState(() => _selectedExercise = e),
                ),

              // Questions list
              Expanded(
                child: filtered.isEmpty
                  ? _EmptySolutions()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) => _QuestionCard(
                        question: filtered[i],
                        index:    i + 1,
                      ),
                    ),
              ),
            ],
          ),
    );
  }
}

// ── EXERCISE TAB BAR ──────────────────────────

class _ExerciseTabBar extends StatelessWidget {
  final List<String> exercises;
  final String       selected;
  final Function(String) onSelect;

  const _ExerciseTabBar({
    required this.exercises,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: exercises.map((e) {
          final isSelected = e == selected;
          return GestureDetector(
            onTap: () => onSelect(e),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isSelected
                  ? AppColors.saffron
                  : AppColors.saffron.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Text(
                  e,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                      ? Colors.white
                      : AppColors.saffron,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── QUESTION CARD ─────────────────────────────

class _QuestionCard extends StatefulWidget {
  final QuestionModel question;
  final int           index;
  const _QuestionCard({
    required this.question,
    required this.index,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool             _expanded = false;
  SolutionModel?   _solution;
  bool             _loadingSolution = false;

  Future<void> _loadSolution() async {
    if (_solution != null) return;
    setState(() => _loadingSolution = true);
    final sol = await context.read<ContentProvider>()
      .getSolution(widget.question.id);
    setState(() {
      _solution       = sol;
      _loadingSolution = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _expanded
            ? AppColors.saffron.withValues(alpha: 0.3)
            : Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          GestureDetector(
            onTap: () {
              setState(() => _expanded = !_expanded);
              if (!_expanded) _loadSolution();
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Q number badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.saffron.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Q${widget.question.questionNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.saffron,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.question.questionText,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                    color: AppColors.muted,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Solution panel
          if (_expanded)
            Container(
              decoration: BoxDecoration(
                color: AppColors.deepGreen.withValues(alpha: 0.04),
                border: Border(
                  top: BorderSide(
                    color: AppColors.deepGreen.withValues(alpha: 0.2),
                  ),
                ),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: _loadingSolution
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _solution == null
                  ? _NoSolution()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: AppColors.deepGreen,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Solution',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepGreen,
                              ),
                            ),
                            const Spacer(),
                            _DifficultyBadge(
                              difficulty: _solution!.difficulty,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        MarkdownBody(
                          data: _solution!.solutionText,
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                            ),
                            strong: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;
  const _DifficultyBadge({required this.difficulty});

  Color get _color {
    switch (difficulty) {
      case 'easy':   return AppColors.deepGreen;
      case 'hard':   return Colors.redAccent;
      default:       return AppColors.gold;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          color: _color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.05,
        ),
      ),
    );
  }
}

class _NoSolution extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'Solution coming soon! ✍️',
          style: TextStyle(color: AppColors.muted),
        ),
      ),
    );
  }
}

class _EmptySolutions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('✏️', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'No questions yet',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Questions and solutions\nwill appear here soon.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
