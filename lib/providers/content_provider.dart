import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/board_model.dart';
import '../models/subject_model.dart';
import '../models/chapter_model.dart';
import '../models/question_model.dart';
import '../models/solution_model.dart';

class ContentProvider extends ChangeNotifier {
  final _db = DatabaseHelper.instance;

  // State
  bool _isLoading = false;
  String? _error;

  List<BoardModel>   _boards   = [];
  List<SubjectModel> _subjects = [];
  List<ChapterModel> _chapters = [];
  List<QuestionModel>_questions= [];

  // Getters
  bool               get isLoading => _isLoading;
  String?            get error     => _error;
  List<BoardModel>   get boards    => _boards;
  List<SubjectModel> get subjects  => _subjects;
  List<ChapterModel> get chapters  => _chapters;
  List<QuestionModel>get questions => _questions;

  // ── BOARDS ──────────────────────────────────

  Future<void> loadBoards() async {
    _setLoading(true);
    try {
      final maps = await _db.query('boards');
      _boards = maps.map(BoardModel.fromMap).toList();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  // ── SUBJECTS ────────────────────────────────

  Future<void> loadSubjects({
    required String boardCode,
    required int classNumber,
  }) async {
    _setLoading(true);
    try {
      final db = await _db.database;
      final maps = await db.rawQuery('''
        SELECT s.*
        FROM subjects s
        JOIN classes  c ON s.class_id  = c.id
        JOIN boards   b ON c.board_id  = b.id
        WHERE b.code = ? AND c.class_number = ?
        ORDER BY s.name
      ''', [boardCode, classNumber]);

      _subjects = maps.map(SubjectModel.fromMap).toList();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  // ── CHAPTERS ────────────────────────────────

  Future<void> loadChapters(int subjectId) async {
    _setLoading(true);
    try {
      final maps = await _db.query(
        'chapters',
        where:     'subject_id = ?',
        whereArgs: [subjectId],
        orderBy:   'number ASC',
      );
      _chapters = maps.map(ChapterModel.fromMap).toList();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  // ── QUESTIONS ───────────────────────────────

  Future<void> loadQuestions(int chapterId) async {
    _setLoading(true);
    try {
      final maps = await _db.query(
        'questions',
        where:     'chapter_id = ?',
        whereArgs: [chapterId],
        orderBy:   'exercise_name ASC, question_number ASC',
      );
      _questions = maps.map(QuestionModel.fromMap).toList();
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  // ── SOLUTION ────────────────────────────────

  Future<SolutionModel?> getSolution(int questionId) async {
    try {
      final maps = await _db.query(
        'solutions',
        where:     'question_id = ?',
        whereArgs: [questionId],
      );
      if (maps.isEmpty) return null;
      return SolutionModel.fromMap(maps.first);
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  // ── SEARCH ──────────────────────────────────

  Future<List<Map<String, dynamic>>> search(String query) async {
    if (query.trim().isEmpty) return [];
    return _db.search(query);
  }

  // ── HELPERS ─────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
