import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../providers/app_provider.dart';
import '../../providers/content_provider.dart';
import '../../models/subject_model.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final app     = context.read<AppProvider>();
      final content = context.read<ContentProvider>();
      content.loadSubjects(
        boardCode:   app.selectedBoard,
        classNumber: app.selectedClass,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final app     = context.watch<AppProvider>();
    final content = context.watch<ContentProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solutions'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                _BoardChip(
                  label: app.selectedBoard,
                  color: AppColors.saffron,
                ),
                const SizedBox(width: 8),
                _BoardChip(
                  label: 'Class ${app.selectedClass}',
                  color: AppColors.skyBlue,
                ),
              ],
            ),
          ),
        ),
      ),
      body: content.isLoading
        ? const Center(child: CircularProgressIndicator())
        : content.subjects.isEmpty
          ? _EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: content.subjects.length,
              itemBuilder: (ctx, i) {
                final subject = content.subjects[i];
                return _SubjectSolutionTile(
                  subject:  subject,
                  language: app.selectedLanguage,
                  onTap: () => context.push(
                    AppRoutes.chapters,
                    extra: subject.id,
                  ),
                );
              },
            ),
    );
  }
}

class _BoardChip extends StatelessWidget {
  final String label;
  final Color  color;
  const _BoardChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SubjectSolutionTile extends StatelessWidget {
  final SubjectModel subject;
  final String       language;
  final VoidCallback onTap;

  const _SubjectSolutionTile({
    required this.subject,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = subject.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  subject.icon ?? '📖',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject.displayName(language),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Tap to see chapters',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('✏️', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text(
            'Solutions coming soon!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We are adding solutions chapter by chapter.',
            style: TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
