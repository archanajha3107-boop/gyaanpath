import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../providers/app_provider.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  String _selectedBoard = 'SSC';
  int    _selectedClass = 10;

  final _boards = [
    {
      'code': 'SSC',
      'name': 'SSC Maharashtra',
      'sub':  'Maharashtra State Board',
      'icon': '🟠',
    },
    {
      'code': 'CBSE',
      'name': 'CBSE',
      'sub':  'Central Board — NCERT Books',
      'icon': '🔵',
    },
  ];

  final _classes = [8, 9, 10];

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

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.skyBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('📚', style: TextStyle(fontSize: 36)),
              ),

              const SizedBox(height: 24),

              const Text(
                'Select Your\nBoard & Class',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'आपला बोर्ड आणि वर्ग निवडा',
                style: TextStyle(fontSize: 15, color: AppColors.muted),
              ),

              const SizedBox(height: 32),

              // Board selection
              Text(
                'YOUR BOARD',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                  color: AppColors.muted,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: _boards.map((board) {
                  final isSelected = _selectedBoard == board['code'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                        setState(() => _selectedBoard = board['code']!),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                            ? AppColors.saffron.withOpacity(0.1)
                            : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                              ? AppColors.saffron
                              : AppColors.borderLight,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(board['icon']!,
                              style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 8),
                            Text(
                              board['name']!,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: isSelected
                                  ? AppColors.saffron : null,
                              ),
                            ),
                            Text(
                              board['sub']!,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Class selection
              Text(
                'YOUR CLASS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                  color: AppColors.muted,
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: _classes.map((cls) {
                  final isSelected = _selectedClass == cls;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () =>
                        setState(() => _selectedClass = cls),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          color: isSelected
                            ? AppColors.saffron.withOpacity(0.1)
                            : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                              ? AppColors.saffron
                              : AppColors.borderLight,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Class',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.muted,
                              ),
                            ),
                            Text(
                              '$cls',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                  ? AppColors.saffron : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onStart,
                  child: const Text("Let's Start Learning →"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onStart() async {
    final appProvider = context.read<AppProvider>();
    await appProvider.setBoard(_selectedBoard);
    await appProvider.setClass(_selectedClass);
    await appProvider.completeOnboarding();
    if (mounted) context.go(AppRoutes.home);
  }
}
