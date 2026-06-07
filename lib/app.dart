import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'constants/app_routes.dart';
import 'providers/app_provider.dart';

class GyaanPathApp extends StatelessWidget {
  const GyaanPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Lock to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final appProvider = context.watch<AppProvider>();

    return MaterialApp.router(
      title: 'GyaanPath',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: appProvider.themeMode,

      // Router
      routerConfig: AppRoutes.router,
    );
  }
}
