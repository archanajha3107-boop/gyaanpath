import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../constants/app_colors.dart';

class OfflineBadge extends StatelessWidget {
  const OfflineBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        final results   = snapshot.data ?? [];
        final isOnline  = results.isNotEmpty &&
          results.any((r) => r != ConnectivityResult.none);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6,
          ),
          decoration: BoxDecoration(
            color: isOnline
              ? AppColors.deepGreen.withOpacity(0.1)
              : AppColors.saffron.withOpacity(0.1),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isOnline
                ? AppColors.deepGreen.withOpacity(0.3)
                : AppColors.saffron.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOnline
                    ? AppColors.deepGreen
                    : AppColors.saffron,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                isOnline
                  ? 'Online'
                  : '📴 Working Offline — All content available',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isOnline
                    ? AppColors.deepGreen
                    : AppColors.saffron,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
