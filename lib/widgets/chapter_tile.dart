import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/chapter_model.dart';

class ChapterTile extends StatelessWidget {
  final ChapterModel chapter;
  final String       language;
  final bool         isCompleted;
  final VoidCallback onTap;

  const ChapterTile({
    super.key,
    required this.chapter,
    required this.language,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCompleted
              ? AppColors.deepGreen.withOpacity(0.4)
              : Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          children: [
            // Chapter number badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted
                  ? AppColors.deepGreen.withOpacity(0.12)
                  : AppColors.saffron.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: isCompleted
                  ? Icon(
                      Icons.check_circle,
                      color: AppColors.deepGreen,
                      size: 20,
                    )
                  : Text(
                      '${chapter.number}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.saffron,
                      ),
                    ),
              ),
            ),

            const SizedBox(width: 14),

            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.displayTitle(language),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Chapter ${chapter.number}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: AppColors.muted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
