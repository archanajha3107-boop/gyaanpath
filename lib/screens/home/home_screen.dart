import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../providers/app_provider.dart';
import '../../providers/content_provider.dart';
import '../../widgets/subject_card.dart';
import '../../widgets/offline_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadContent());
  }

  void _loadContent() {
    final app     = context.read<AppProvider>();
    final content = context.read<ContentProvider>();
    content.loadSubjects(
      boardCode:   app.selectedBoard,
      classNumber: app.selectedClass,
    );
  }

  @override
  Widget build(BuildContext context) {
    final app     = context.watch<AppProvider>();
    final content = context.watch<ContentProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── APP BAR ──────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              background: _HomeHeader(
                boardCode:   app.selectedBoard,
                classNumber: app.selectedClass,
                studentName: app.studentName,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  app.themeMode == ThemeMode.dark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                ),
                onPressed: app.toggleTheme,
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _showSearch(context),
              ),
            ],
          ),

          // ── OFFLINE BADGE ────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: const OfflineBadge(),
            ),
          ),

          // ── QUICK ACCESS GRID ────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: _QuickAccessGrid(),
            ),
          ),

          // ── SUBJECTS HEADER ──────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Row(
                children: [
                  Text(
                    'Your Subjects',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${app.selectedBoard} · Class ${app.selectedClass}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── SUBJECTS LIST ────────────────────
          content.isLoading
            ? const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            : content.subjects.isEmpty
              ? SliverFillRemaining(
                  child: _EmptySubjects(onRetry: _loadContent),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => SubjectCard(
                        subject: content.subjects[i],
                        language: app.selectedLanguage,
                        onTapTextbook: () => context.push(
                          AppRoutes.textbook,
                          extra: content.subjects[i].pdfAsset ?? '',
                        ),
                        onTapSolutions: () => context.push(
                          AppRoutes.chapters,
                          extra: content.subjects[i].id,
                        ),
                      ),
                      childCount: content.subjects.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _showSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: _GyaanSearchDelegate(
        context.read<ContentProvider>(),
      ),
    );
  }
}

// ── HOME HEADER ───────────────────────────────

class _HomeHeader extends StatelessWidget {
  final String boardCode;
  final int    classNumber;
  final String studentName;

  const _HomeHeader({
    required this.boardCode,
    required this.classNumber,
    required this.studentName,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$_greeting, $studentName 👋',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.appName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.saffron.withOpacity(0.12),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: AppColors.saffron.withOpacity(0.3),
              ),
            ),
            child: Text(
              '$boardCode · Class $classNumber',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.saffron,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── QUICK ACCESS GRID ─────────────────────────

class _QuickAccessGrid extends StatelessWidget {
  final _items = [
    {
      'icon':  Icons.menu_book_outlined,
      'label': 'Textbooks',
      'color': AppColors.saffron,
      'route': AppRoutes.subjects,
    },
    {
      'icon':  Icons.lightbulb_outline,
      'label': 'Solutions',
      'color': AppColors.deepGreen,
      'route': AppRoutes.subjects,
    },
    {
      'icon':  Icons.description_outlined,
      'label': 'Papers',
      'color': AppColors.skyBlue,
      'route': AppRoutes.papers,
    },
    {
      'icon':  Icons.quiz_outlined,
      'label': 'Quiz',
      'color': AppColors.gold,
      'route': AppRoutes.quiz,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: _items.map((item) {
        final color = item['color'] as Color;
        return GestureDetector(
          onTap: () => context.push(item['route'] as String),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: color.withOpacity(0.25),
                  ),
                ),
                child: Icon(
                  item['icon'] as IconData,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item['label'] as String,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── EMPTY STATE ───────────────────────────────

class _EmptySubjects extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptySubjects({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('📚', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              'No subjects loaded yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Content is being added.\nCheck back soon!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── SEARCH DELEGATE ───────────────────────────

class _GyaanSearchDelegate extends SearchDelegate {
  final ContentProvider _content;
  _GyaanSearchDelegate(this._content);

  @override
  String get searchFieldLabel => AppStrings.search;

  @override
  List<Widget> buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => _buildSearch();

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearch();

  Widget _buildSearch() {
    if (query.trim().isEmpty) {
      return Center(
        child: Text(
          'Type to search solutions, chapters...',
          style: TextStyle(color: AppColors.muted),
        ),
      );
    }
    return FutureBuilder(
      future: _content.search(query),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final results = snap.data ?? [];
        if (results.isEmpty) {
          return Center(
            child: Text(
              'No results for "$query"',
              style: TextStyle(color: AppColors.muted),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: results.length,
          itemBuilder: (ctx, i) {
            final r = results[i];
            return ListTile(
              title: Text(r['title'] ?? ''),
              subtitle: Text(r['type'] ?? ''),
              leading: const Icon(Icons.search),
            );
          },
        );
      },
    );
  }
}
