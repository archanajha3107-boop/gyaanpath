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
                  color: const Color(0x1A4A9EFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('📚', style: TextStyle(fontSize: 36)),
              ),
              const SizedBox(height: 24),
              const Text('Select Your Board & Class',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('आपला बोर्ड आणि वर्ग निवडा',
                style: TextStyle(fontSize: 15, color: Color(0xFF7A8099))),
              const SizedBox(height: 32),
              const Text('YOUR BOARD',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  letterSpacing: 0.1, color: Color(0xFF7A8099))),
              const SizedBox(height: 12),
              Row(children: [
                _BoardCard(code: 'SSC',  name: 'SSC Maharashtra',
                  sub: 'Maharashtra State Board', icon: '🟠',
                  isSelected: _selectedBoard == 'SSC',
                  onTap: () => setState(() => _selectedBoard = 'SSC')),
                const SizedBox(width: 10),
                _BoardCard(code: 'CBSE', name: 'CBSE',
                  sub: 'Central Board — NCERT', icon: '🔵',
                  isSelected: _selectedBoard == 'CBSE',
                  onTap: () => setState(() => _selectedBoard = 'CBSE')),
              ]),
              const SizedBox(height: 32),
              const Text('YOUR CLASS',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  letterSpacing: 0.1, color: Color(0xFF7A8099))),
              const SizedBox(height: 12),
              Row(children: [8, 9, 10].map((cls) {
                final sel = _selectedClass == cls;
                return Expanded(child: GestureDetector(
                  onTap: () => setState(() => _selectedClass = cls),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0x1AFF7A1A) : Colors.transparent,
                      border: Border.all(
                        color: sel ? const Color(0xFFFF7A1A) : const Color(0xFFEDE8DF),
                        width: sel ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(children: [
                      Text('Class',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF7A8099))),
                      Text('$cls', style: TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w700,
                        color: sel ? const Color(0xFFFF7A1A) : null)),
                    ]),
                  ),
                ));
              }).toList()),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final app = context.read<AppProvider>();
                    await app.setBoard(_selectedBoard);
                    await app.setClass(_selectedClass);
                    await app.completeOnboarding();
                    if (mounted) context.go(AppRoutes.home);
                  },
                  child: const Text("Let's Start Learning →"),
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

class _BoardCard extends StatelessWidget {
  final String code, name, sub, icon;
  final bool isSelected;
  final VoidCallback onTap;
  const _BoardCard({required this.code, required this.name,
    required this.sub, required this.icon,
    required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x1AFF7A1A) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFFFF7A1A) : const Color(0xFFEDE8DF),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(name, style: TextStyle(
            fontWeight: FontWeight.w700, fontSize: 15,
            color: isSelected ? const Color(0xFFFF7A1A) : null)),
          Text(sub, style: const TextStyle(fontSize: 11, color: Color(0xFF7A8099))),
        ]),
      ),
    ));
  }
}
