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
    {'code': 'en', 'label': 'English', 'sublabel': 'English Medium'},
    {'code': 'mr', 'label': 'मराठी',   'sublabel': 'Marathi Medium'},
    {'code': 'hi', 'label': 'हिंदी',   'sublabel': 'Hindi Medium'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0x1AFF7A1A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('🌐', style: TextStyle(fontSize: 36)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Choose Your Language',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text('भाषा निवडा / भाषा चुनें',
                style: TextStyle(fontSize: 16, color: Color(0xFF7A8099))),
              const SizedBox(height: 40),
              ...([
                {'code': 'en', 'label': 'English', 'sublabel': 'English Medium'},
                {'code': 'mr', 'label': 'मराठी',   'sublabel': 'Marathi Medium'},
                {'code': 'hi', 'label': 'हिंदी',   'sublabel': 'Hindi Medium'},
              ].map((lang) => GestureDetector(
                onTap: () => setState(() => _selected = lang['code']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _selected == lang['code']
                      ? const Color(0x1AFF7A1A) : Colors.transparent,
                    border: Border.all(
                      color: _selected == lang['code']
                        ? const Color(0xFFFF7A1A) : const Color(0xFFEDE8DF),
                      width: _selected == lang['code'] ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    Container(
                      width: 22, height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selected == lang['code']
                            ? const Color(0xFFFF7A1A) : const Color(0xFF7A8099),
                          width: 2,
                        ),
                        color: _selected == lang['code']
                          ? const Color(0xFFFF7A1A) : Colors.transparent,
                      ),
                      child: _selected == lang['code']
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                    ),
                    const SizedBox(width: 16),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(lang['label']!,
                        style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600,
                          color: _selected == lang['code']
                            ? const Color(0xFFFF7A1A) : null,
                        )),
                      Text(lang['sublabel']!,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF7A8099))),
                    ]),
                  ]),
                ),
              ))),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.read<AppProvider>().setLanguage(_selected);
                    if (mounted) context.go(AppRoutes.board);
                  },
                  child: const Text('Next →'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
