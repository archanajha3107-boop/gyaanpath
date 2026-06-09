import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/board_model.dart';
import '../models/subject_model.dart';
import '../models/chapter_model.dart';
import '../models/question_model.dart';
import '../models/solution_model.dart';

class ContentProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;

  bool _isLoading = false;
  String? _error;

  List<BoardModel>    _boards    = [];
  List<SubjectModel>  _subjects  = [];
  List<ChapterModel>  _chapters  = [];
  List<QuestionModel> _questions = [];

  bool                get isLoading => _isLoading;
  String?             get error     => _error;
  List<BoardModel>    get boards    => _boards;
  List<SubjectModel>  get subjects  => _subjects;
  List<ChapterModel>  get chapters  => _chapters;
  List<QuestionModel> get questions => _questions;

  Future<void> loadSubjects({
    required String boardCode,
    required int classNumber,
  }) async {
    _setLoading(true);
    try {
      // On web — show demo subjects since SQLite unavailable
      if (kIsWeb) {
        _subjects = _demoSubjects(boardCode, classNumber);
        _setLoading(false);
        return;
      }
      final db   = await _db.database;
      final maps = await db.rawQuery('''
        SELECT s.*
        FROM subjects s
        JOIN classes  c ON s.class_id = c.id
        JOIN boards   b ON c.board_id = b.id
        WHERE b.code = ? AND c.class_number = ?
        ORDER BY s.name
      ''', [boardCode, classNumber]);
      _subjects = maps.map(SubjectModel.fromMap).toList();
    } catch (e) {
      _error    = e.toString();
      _subjects = _demoSubjects(boardCode, classNumber);
    }
    _setLoading(false);
  }

  Future<void> loadChapters(int subjectId) async {
    _setLoading(true);
    try {
      if (kIsWeb) {
        _chapters = _demoChapters(subjectId);
        _setLoading(false);
        return;
      }
      final maps = await _db.query(
        'chapters',
        where:     'subject_id = ?',
        whereArgs: [subjectId],
        orderBy:   'number ASC',
      );
      _chapters = maps.map(ChapterModel.fromMap).toList();
    } catch (e) {
      _error    = e.toString();
      _chapters = _demoChapters(subjectId);
    }
    _setLoading(false);
  }

  Future<void> loadQuestions(int chapterId) async {
    _setLoading(true);
    try {
      if (kIsWeb) {
        _questions = _demoQuestions(chapterId);
        _setLoading(false);
        return;
      }
      final maps = await _db.query(
        'questions',
        where:     'chapter_id = ?',
        whereArgs: [chapterId],
        orderBy:   'exercise_name ASC, question_number ASC',
      );
      _questions = maps.map(QuestionModel.fromMap).toList();
    } catch (e) {
      _error     = e.toString();
      _questions = _demoQuestions(chapterId);
    }
    _setLoading(false);
  }

  Future<SolutionModel?> getSolution(int questionId) async {
    try {
      if (kIsWeb) return _demoSolution(questionId);
      final maps = await _db.query(
        'solutions',
        where:     'question_id = ?',
        whereArgs: [questionId],
      );
      if (maps.isEmpty) return null;
      return SolutionModel.fromMap(maps.first);
    } catch (e) {
      return _demoSolution(questionId);
    }
  }

  Future<List<Map<String, dynamic>>> search(String query) async {
    if (query.trim().isEmpty) return [];
    if (kIsWeb) return [];
    return _db.search(query);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ── DEMO DATA FOR WEB PREVIEW ─────────────

  List<SubjectModel> _demoSubjects(String board, int cls) => [
    SubjectModel(id: 1, classId: 1, name: 'Mathematics',
      icon: '📐', colorHex: 'FF7A1A'),
    SubjectModel(id: 2, classId: 1, name: 'Science Part 1',
      icon: '🔬', colorHex: '2EC97A'),
    SubjectModel(id: 3, classId: 1, name: 'Science Part 2',
      icon: '⚗️', colorHex: '4A9EFF'),
    SubjectModel(id: 4, classId: 1, name: 'History & Pol. Science',
      icon: '🏛️', colorHex: 'F5C842'),
    SubjectModel(id: 5, classId: 1, name: 'Geography',
      icon: '🗺️', colorHex: 'FF4D8F'),
    SubjectModel(id: 6, classId: 1, name: 'English',
      icon: '📝', colorHex: '7C3AED'),
  ];

  List<ChapterModel> _demoChapters(int subjectId) => [
    ChapterModel(id: 1, subjectId: subjectId, number: 1,
      title: 'Real Numbers'),
    ChapterModel(id: 2, subjectId: subjectId, number: 2,
      title: 'Polynomials'),
    ChapterModel(id: 3, subjectId: subjectId, number: 3,
      title: 'Pair of Linear Equations'),
    ChapterModel(id: 4, subjectId: subjectId, number: 4,
      title: 'Quadratic Equations'),
    ChapterModel(id: 5, subjectId: subjectId, number: 5,
      title: 'Arithmetic Progressions'),
  ];

  List<QuestionModel> _demoQuestions(int chapterId) => [
    QuestionModel(id: 1, chapterId: chapterId,
      exerciseName: 'Exercise 1.1', questionNumber: '1',
      questionText: 'Use Euclid\'s division algorithm to find the HCF of 135 and 225.',
      questionType: 'long'),
    QuestionModel(id: 2, chapterId: chapterId,
      exerciseName: 'Exercise 1.1', questionNumber: '2',
      questionText: 'Find the HCF of 196 and 38220 using Euclid\'s division algorithm.',
      questionType: 'long'),
    QuestionModel(id: 3, chapterId: chapterId,
      exerciseName: 'Exercise 1.2', questionNumber: '1',
      questionText: 'Express each number as a product of its prime factors: (i) 140',
      questionType: 'short'),
  ];

  SolutionModel _demoSolution(int questionId) => SolutionModel(
    id: questionId,
    questionId: questionId,
    difficulty: 'medium',
    solutionText: '''
**Step 1:** Apply Euclid\'s Division Lemma

Since 225 > 135, apply the lemma to 225 and 135:

**225 = 135 × 1 + 90**

**Step 2:** Apply lemma to 135 and 90:

**135 = 90 × 1 + 45**

**Step 3:** Apply lemma to 90 and 45:

**90 = 45 × 2 + 0**

Since the remainder is **0**, we stop.

∴ **HCF (135, 225) = 45** ✅
''',
  );
}
