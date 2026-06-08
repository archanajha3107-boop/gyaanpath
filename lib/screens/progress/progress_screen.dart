import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/app_provider.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app      = context.watch<AppProvider>();
    final settings = Hive.box('settings');
    final name     = settings.get('student_name', defaultValue: 'Student');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Progress'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student card
            _StudentCard(
              name:      name,
              board:     app.selectedBoard,
              classNum:  app.selectedClass,
            ),

            const SizedBox(height: 24),

            // Stats row
            Row(
              children: [
                _StatCard(
                  label: 'Chapters\nRead',
                  value: '0',
                  icon:  '📖',
                  color: AppColors.saffron,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Solutions\nViewed',
                  value: '0',
                  icon:  '✏️',
                  color: AppColors.deepGreen,
                ),
                const SizedBox(width: 12),
                _StatCard(
                  label: 'Quiz\nScore',
                  value: '0%',
                  icon:  '🎯',
                  color: AppColors.skyBlue,
                ),
              ],
            ),

            const SizedBox(height: 28),

            Text(
              'SUBJECT PROGRESS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
                color: AppColors.muted,
              ),
            ),

            const SizedBox(height: 12),

            // Subject progress bars
            _SubjectProgress(
              subject:   'Mathematics',
              icon:      '📐',
              completed: 0,
              total:     15,
              color:     AppColors.saffron,
            ),
            _SubjectProgress(
              subject:   'Science Part 1',
              icon:      '🔬',
              completed: 0,
              total:     12,
              color:     AppColors.deepGreen,
            ),
            _SubjectProgress(
              subject:   'Science Part 2',
              icon:      '⚗️',
              completed: 0,
              total:     10,
              color:     AppColors.skyBlue,
            ),
            _SubjectProgress(
              subject:   'History & Pol. Sci.',
              icon:      '🏛️',
              completed: 0,
              total:     8,
              color:     AppColors.gold,
            ),

            const SizedBox(height: 28),

            // Update name
            Text(
              'SETTINGS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
                color: AppColors.muted,
              ),
            ),

            const SizedBox(height: 12),

            _SettingsTile(
              icon:  Icons.person_outline,
              label: 'Your Name',
              value: name,
              onTap: () => _showNameDialog(context, app),
            ),
            _SettingsTile(
              icon:  Icons.school_outlined,
              label: 'Board',
              value: app.selectedBoard,
              onTap: () {},
            ),
            _SettingsTile(
              icon:  Icons.brightness_6_outlined,
              label: 'Dark Mode',
              value: app.themeMode == ThemeMode.dark ? 'On' : 'Off',
              onTap: app.toggleTheme,
            ),
          ],
        ),
      ),
    );
  }

  void _showNameDialog(BuildContext context, AppProvider app) {
    final ctrl = TextEditingController(text: app.studentName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Your Name'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: 'Enter your name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              app.setStudentName(ctrl.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  final String name;
  final String board;
  final int    classNum;

  const _StudentCard({
    required this.name,
    required this.board,
    required this.classNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.saffron,
            AppColors.saffron.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end:   Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'S',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                '$board · Class $classNum',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color  color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.muted,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubjectProgress extends StatelessWidget {
  final String subject;
  final String icon;
  final int    completed;
  final int    total;
  final Color  color;

  const _SubjectProgress({
    required this.subject,
    required this.icon,
    required this.completed,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : completed / total;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '$completed/$total',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final String       value;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.muted),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.chevron_right,
              color: AppColors.muted, size: 18),
          ],
        ),
      ),
    );
  }
}
