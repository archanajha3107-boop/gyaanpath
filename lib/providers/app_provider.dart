import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppProvider extends ChangeNotifier {
  late Box _settings;

  // User preferences
  String _selectedBoard    = 'SSC';
  int    _selectedClass    = 10;
  String _selectedLanguage = 'en';
  ThemeMode _themeMode     = ThemeMode.light;
  bool _onboardingDone     = false;

  // Getters
  String    get selectedBoard    => _selectedBoard;
  int       get selectedClass    => _selectedClass;
  String    get selectedLanguage => _selectedLanguage;
  ThemeMode get themeMode        => _themeMode;
  bool      get onboardingDone   => _onboardingDone;

  // Is Marathi selected
  bool get isMarathi => _selectedLanguage == 'mr';
  bool get isHindi   => _selectedLanguage == 'hi';
  bool get isEnglish => _selectedLanguage == 'en';

  AppProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    _settings        = Hive.box('settings');
    _selectedBoard   = _settings.get('board',    defaultValue: 'SSC');
    _selectedClass   = _settings.get('class',    defaultValue: 10);
    _selectedLanguage= _settings.get('language', defaultValue: 'en');
    _onboardingDone  = _settings.get('onboarding_done', defaultValue: false);

    final isDark     = _settings.get('dark_mode', defaultValue: false);
    _themeMode       = isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  // Set board (SSC / CBSE)
  Future<void> setBoard(String board) async {
    _selectedBoard = board;
    await _settings.put('board', board);
    notifyListeners();
  }

  // Set class number
  Future<void> setClass(int classNumber) async {
    _selectedClass = classNumber;
    await _settings.put('class', classNumber);
    notifyListeners();
  }

  // Set language
  Future<void> setLanguage(String langCode) async {
    _selectedLanguage = langCode;
    await _settings.put('language', langCode);
    notifyListeners();
  }

  // Toggle dark/light theme
  Future<void> toggleTheme() async {
    final isDark = _themeMode == ThemeMode.dark;
    _themeMode   = isDark ? ThemeMode.light : ThemeMode.dark;
    await _settings.put('dark_mode', !isDark);
    notifyListeners();
  }

  // Mark onboarding complete
  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    await _settings.put('onboarding_done', true);
    notifyListeners();
  }

  // Get student name
  String get studentName =>
    _settings.get('student_name', defaultValue: 'Student');

  Future<void> setStudentName(String name) async {
    await _settings.put('student_name', name);
    notifyListeners();
  }
}
