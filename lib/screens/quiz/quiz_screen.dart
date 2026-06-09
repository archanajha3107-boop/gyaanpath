import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int     _currentIndex  = 0;
  int     _score         = 0;
  String? _selectedOption;
  bool    _answered      = false;
  bool    _quizDone      = false;

  // Placeholder questions — will come from SQLite later
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the chemical formula of water?',
      'options':  ['H2O', 'CO2', 'NaCl', 'O2'],
      'answer':   'H2O',
      'explain':  'Water is made of 2 hydrogen atoms and 1 oxygen atom.',
    },
    {
      'question': 'Which planet is closest to the Sun?',
      'options':  ['Venus', 'Earth', 'Mercury', 'Mars'],
      'answer':   'Mercury',
      'explain':  'Mercury is the first planet in our solar system.',
    },
    {
      'question': 'What is the value of π (pi) approximately?',
      'options':  ['3.14', '2.71', '1.61', '1.41'],
      'answer':   '3.14',
      'explain':  'Pi (π) ≈ 3.14159... used in circle calculations.',
    },
    {
      'question': 'Photosynthesis occurs in which part of the plant?',
      'options':  ['Root', 'Stem', 'Leaf', 'Flower'],
      'answer':   'Leaf',
      'explain':  'Leaves contain chlorophyll which traps sunlight.',
    },
    {
      'question': 'What is the SI unit of force?',
      'options':  ['Watt', 'Newton', 'Joule', 'Pascal'],
      'answer':   'Newton',
      'explain':  'Force = mass × acceleration. Unit is Newton (N).',
    },
  ];

  void _selectOption(String option) {
    if (_answered) return;
    setState(() {
      _selectedOption = option;
      _answered       = true;
      if (option == _questions[_currentIndex]['answer']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered       = false;
      });
    } else {
      setState(() => _quizDone = true);
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex  = 0;
      _score         = 0;
      _selectedOption= null;
      _answered      = false;
      _quizDone      = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizDone) return _QuizResult(
      score:    _score,
      total:    _questions.length,
      onRetry:  _restartQuiz,
    );

    final q = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Quiz'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: AppColors.borderLight,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.saffron),
            minHeight: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question counter
            Text(
              'Question ${_currentIndex + 1} of ${_questions.length}',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.muted,
              ),
            ),

            const SizedBox(height: 16),

            // Score badge
            Row(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '⭐ Score: $_score',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Question
            Container(
              width:   double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.saffron.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.saffron.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                q['question'] as String,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Options
            ...(q['options'] as List<String>).map((option) {
              return _OptionTile(
                option:    option,
                isCorrect: option == q['answer'],
                isSelected:option == _selectedOption,
                answered:  _answered,
                onTap: () => _selectOption(option),
              );
            }),

            const Spacer(),

            // Explanation
            if (_answered)
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.deepGreen.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.deepGreen.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb,
                      color: AppColors.deepGreen, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        q['explain'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.deepGreen,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Next button
            if (_answered)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextQuestion,
                  child: Text(
                    _currentIndex < _questions.length - 1
                      ? 'Next Question →'
                      : 'See Results →',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── OPTION TILE ───────────────────────────────

class _OptionTile extends StatelessWidget {
  final String option;
  final bool   isCorrect;
  final bool   isSelected;
  final bool   answered;
  final VoidCallback onTap;

  const _OptionTile({
    required this.option,
    required this.isCorrect,
    required this.isSelected,
    required this.answered,
    required this.onTap,
  });

  Color _getBorderColor() {
    if (!answered) return AppColors.borderLight;
    if (isCorrect) return AppColors.deepGreen;
    if (isSelected && !isCorrect) return Colors.redAccent;
    return AppColors.borderLight;
  }

  Color _getBgColor() {
    if (!answered) return Colors.transparent;
    if (isCorrect) return AppColors.deepGreen.withValues(alpha: 0.08);
    if (isSelected && !isCorrect) return Colors.redAccent.withValues(alpha: 0.06);
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _getBgColor(),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _getBorderColor(),
            width: answered && (isCorrect || isSelected) ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            if (answered && isCorrect)
              Icon(Icons.check_circle,
                color: AppColors.deepGreen, size: 20),
            if (answered && isSelected && !isCorrect)
              const Icon(Icons.cancel,
                color: Colors.redAccent, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── QUIZ RESULT ───────────────────────────────

class _QuizResult extends StatelessWidget {
  final int          score;
  final int          total;
  final VoidCallback onRetry;

  const _QuizResult({
    required this.score,
    required this.total,
    required this.onRetry,
  });

  String get _emoji {
    final pct = score / total;
    if (pct >= 0.8) return '🏆';
    if (pct >= 0.6) return '👍';
    if (pct >= 0.4) return '📚';
    return '💪';
  }

  String get _message {
    final pct = score / total;
    if (pct >= 0.8) return 'Excellent! Keep it up!';
    if (pct >= 0.6) return 'Good job! Practice more!';
    if (pct >= 0.4) return 'Keep studying, you got this!';
    return 'Don\'t give up, try again!';
  }

  @override
  Widget build(BuildContext context) {
    final pct = score / total;
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Result')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_emoji, style: const TextStyle(fontSize: 72)),
              const SizedBox(height: 24),
              Text(
                '$score / $total',
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  color: AppColors.saffron,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 10,
                  backgroundColor: AppColors.borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.saffron,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Try Again 🔄'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
