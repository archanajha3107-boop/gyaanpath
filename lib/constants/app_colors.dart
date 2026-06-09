import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const saffron     = Color(0xFFFF7A1A);
  static const saffronLight= Color(0xFFFF9A50);
  static const gold        = Color(0xFFF5C842);
  static const deepGreen   = Color(0xFF2EC97A);
  static const skyBlue     = Color(0xFF4A9EFF);

  // Light Theme backgrounds
  static const bgLight     = Color(0xFFFAF7F2);
  static const cardLight   = Color(0xFFFFFFFF);
  static const borderLight = Color(0xFFEDE8DF);

  // Dark Theme backgrounds
  static const bgDark      = Color(0xFF0D0F14);
  static const cardDark    = Color(0xFF181C28);
  static const borderDark  = Color(0xFF252B3B);

  // Text
  static const textDark    = Color(0xFF1A1A2E);
  static const textLight   = Color(0xFFE8E4DC);
  static const muted       = Color(0xFF7A8099);

  // ── LIGHT THEME ──────────────────────────────
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: saffron,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: bgLight,
    fontFamily: 'Mukta',
    appBarTheme: const AppBarTheme(
      backgroundColor: bgLight,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Mukta',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textDark,
      ),
      iconTheme: IconThemeData(color: textDark),
    ),
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderLight),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: saffron,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24, vertical: 14,
        ),
        textStyle: const TextStyle(
          fontFamily: 'Mukta',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
  );

  // ── DARK THEME ───────────────────────────────
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: saffron,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: bgDark,
    fontFamily: 'Mukta',
    appBarTheme: const AppBarTheme(
      backgroundColor: bgDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Mukta',
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textLight,
      ),
      iconTheme: IconThemeData(color: textLight),
    ),
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderDark),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: saffron,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24, vertical: 14,
        ),
        textStyle: const TextStyle(
          fontFamily: 'Mukta',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
  );
}
