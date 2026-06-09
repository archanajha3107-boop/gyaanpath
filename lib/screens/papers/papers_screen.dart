import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../providers/app_provider.dart';

class PapersScreen extends StatelessWidget {
  const PapersScreen({super.key});
  static const _years = [2024, 2023, 2022, 2021, 2020, 2019, 2018];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Question Papers')),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.skyBlue.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              Icon(Icons.info_outline, color: AppColors.skyBlue, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${app.selectedBoard} · Class ${app.selectedClass} · Last ${_years.length} years',
                  style: TextStyle(fontSize: 13, color: AppColors.skyBlue),
                ),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              itemCount: _years.length,
              itemBuilder: (ctx, i) {
                final year = _years[i];
                return GestureDetector(
                  onTap: () => ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('$year paper — PDF coming soon!')),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Row(children: [
                      Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.skyBlue.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text('$year',
                            style: TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.skyBlue)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${app.selectedBoard} Board — $year',
                            style: const TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w600)),
                          Text('Class ${app.selectedClass} · March $year',
                            style: TextStyle(fontSize: 12, color: AppColors.muted)),
                        ],
                      )),
                      Icon(Icons.picture_as_pdf_outlined,
                        color: AppColors.skyBlue, size: 20),
                    ]),
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
