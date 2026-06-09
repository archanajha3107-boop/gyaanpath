import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../providers/app_provider.dart';
import '../../providers/content_provider.dart';
import '../../widgets/chapter_tile.dart';

class ChaptersScreen extends StatefulWidget {
  final int subjectId;
  const ChaptersScreen({super.key, required this.subjectId});

  @override
  State<ChaptersScreen> createState() => _ChaptersScreenState();
}

class _ChaptersScreenState extends State<ChaptersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContentProvider>().loadChapters(widget.subjectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final app     = context.watch<AppProvider>();
    final content = context.watch<ContentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapters'),
      ),
      body: content.isLoading
        ? const Center(child: CircularProgressIndicator())
        : content.chapters.isEmpty
          ? _EmptyChapters()
          : Column(
              children: [
                // Progress bar
                _ChapterProgress(
                  total:     content.chapters.length,
                  completed: 0,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: content.chapters.length,
                    itemBuilder: (ctx, i) {
                      final chapter = content.chapters[i];
                      return ChapterTile(
                        chapter:     chapter,
                        language:    app.selectedLanguage,
                        isCompleted: false,
                        onTap: () => context.push(
                          AppRoutes.solution,
                          extra: chapter.id,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _ChapterProgress extends StatelessWidget {
  final int total;
  final int completed;
  const _ChapterProgress({
    required this.total,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : completed / total;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completed / $total chapters done',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.muted,
                ),
              ),
              Text(
                '${(pct * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.saffron,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value:            pct,
              minHeight:        6,
              backgroundColor:  AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.saffron),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChapters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📑', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text(
            'Chapters coming soon',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Solutions are being added by our teachers.',
            style: TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
