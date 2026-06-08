import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../providers/app_provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = 'en';

  final _languages = [
    {'code': 'en', 'label': 'English',  'sublabel': 'English Medium'},
    {'code': 'mr', 'label': 'मराठी',     'sublabel': 'Marathi Medium'},
    {'code': 'hi', 'label': 'हिंदी',     'sublabel': 'Hindi Medium'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.saffron.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('🌐', style: TextStyle(fontSize: 36)),
              ),

              const SizedBox(height: 24),

              const Text(
                'Choose Your\nLanguage',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'भाषा निवडा / भाषा चुनें',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.muted,
                ),
              ),

              const SizedBox(height: 40),

              // Language Options
              ...(_languages.map((lang) => _LanguageTile(
                code:      lang['code']!,
                label:     lang['label']!,
                sublabel:  lang['sublabel']!,
                isSelected:_selected == lang['code'],
                onTap: () => setState(() => _selected = lang['code']!),
              ))),

              const Spacer(),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNext,
                  child: const Text('Next →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onNext() async {
    final appProvider = context.read<AppProvider>();
    await appProvider.setLanguage(_selected);
    if (mounted) context.go(AppRoutes.board);
  }
}

class _LanguageTile extends StatelessWidget {
  final String code;
  final String label;
  final String sublabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.code,
    required this.label,
    required this.sublabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected
            ? AppColors.saffron.withOpacity(0.1)
            : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.saffron : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.saffron : AppColors.muted,
                  width: 2,
                ),
                color: isSelected ? AppColors.saffron : Colors.transparent,
              ),
              child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : null,
            ),

            const SizedBox(width: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.saffron : null,
                  ),
                ),
                Text(
                  sublabel,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
