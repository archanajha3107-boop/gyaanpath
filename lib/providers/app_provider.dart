import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppProvider extends ChangeNotifier {
  String _selectedBoard    = 'SSC';
  int    _selectedClass    = 10;
  String _selectedLanguage = 'en';
  ThemeMode _themeMode     = ThemeMode.light;
  bool _onboardingDone     = false;

  String    get selectedBoard    => _selectedBoard;
  int       get selectedClass    => _selectedClass;
  String    get selectedLanguage => _selectedLanguage;
  ThemeMode get themeMode        => _themeMode;
  bool      get onboardingDone   => _onboardingDone;
  bool get isMarathi => _selectedLanguage == 'mr';
  bool get isHindi   => _selectedLanguage == 'hi';
  bool get isEnglish => _selectedLanguage == 'en';

  AppProvider() { _loadSettings(); }

  void _loadSettings() {
    try {
      final settings       = Hive.box('settings');
      _selectedBoard       = settings.get('board',    defaultValue: 'SSC');
      _selectedClass       = settings.get('class',    defaultValue: 10);
      _selectedLanguage    = settings.get('language', defaultValue: 'en');
      _onboardingDone      = settings.get('onboarding_done', defaultValue: false);
      final isDark         = settings.get('dark_mode', defaultValue: false);
      _themeMode           = isDark ? ThemeMode.dark : ThemeMode.light;
    } catch (e) {
      debugPrint('Settings load error: $e');
    }
    notifyListeners();
  }

  Future<void> setBoard(String board) async {
    _selectedBoard = board;
    await _save('board', board);
  }

  Future<void> setClass(int classNumber) async {
    _selectedClass = classNumber;
    await _save('class', classNumber);
  }

  Future<void> setLanguage(String langCode) async {
    _selectedLanguage = langCode;
    await _save('language', langCode);
  }

  Future<void> toggleTheme() async {
    final isDark = _themeMode == ThemeMode.dark;
    _themeMode   = isDark ? ThemeMode.light : ThemeMode.dark;
    await _save('dark_mode', !isDark);
  }

  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    await _save('onboarding_done', true);
  }

  String get studentName =>
    Hive.box('settings').get('student_name', defaultValue: 'Student');

  Future<void> setStudentName(String name) async {
    await _save('student_name', name);
  }

  Future<void> _save(String key, dynamic value) async {
    try {
      await Hive.box('settings').put(key, value);
    } catch (e) {
      debugPrint('Save error: $e');
    }
    notifyListeners();
  }
}
