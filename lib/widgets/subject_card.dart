import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/subject_model.dart';

class SubjectCard extends StatelessWidget {
  final SubjectModel  subject;
  final String        language;
  final VoidCallback  onTapTextbook;
  final VoidCallback  onTapSolutions;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.language,
    required this.onTapTextbook,
    required this.onTapSolutions,
  });

  @override
  Widget build(BuildContext context) {
    final color = subject.color;
    final name  = subject.displayName(language);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        children: [
          // Subject Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
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

                // Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        subject.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),

                // PDF available indicator
                if (subject.pdfAsset != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.deepGreen.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'PDF ✓',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: Row(
              children: [
                _ActionButton(
                  icon:  Icons.menu_book_outlined,
                  label: 'Textbook',
                  color: AppColors.saffron,
                  onTap: onTapTextbook,
                  enabled: subject.pdfAsset != null,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).dividerColor,
                ),
                _ActionButton(
                  icon:  Icons.lightbulb_outline,
                  label: 'Solutions',
                  color: AppColors.deepGreen,
                  onTap: onTapSolutions,
                  enabled: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final Color        color;
  final VoidCallback onTap;
  final bool         enabled;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: enabled ? color : AppColors.muted,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: enabled ? color : AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
