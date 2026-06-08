import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gyaanpath.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Boards table (SSC Maharashtra, CBSE)
    await db.execute('''
      CREATE TABLE boards (
        id      INTEGER PRIMARY KEY AUTOINCREMENT,
        name    TEXT NOT NULL,
        code    TEXT NOT NULL UNIQUE
      )
    ''');

    // Classes table (8, 9, 10, 11, 12)
    await db.execute('''
      CREATE TABLE classes (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        board_id     INTEGER NOT NULL,
        class_number INTEGER NOT NULL,
        FOREIGN KEY (board_id) REFERENCES boards(id)
      )
    ''');

    // Subjects table
    await db.execute('''
      CREATE TABLE subjects (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        class_id      INTEGER NOT NULL,
        name          TEXT NOT NULL,
        name_marathi  TEXT,
        name_hindi    TEXT,
        icon          TEXT,
        pdf_asset     TEXT,
        color_hex     TEXT,
        FOREIGN KEY (class_id) REFERENCES classes(id)
      )
    ''');

    // Chapters table
    await db.execute('''
      CREATE TABLE chapters (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id      INTEGER NOT NULL,
        number          INTEGER NOT NULL,
        title           TEXT NOT NULL,
        title_marathi   TEXT,
        title_hindi     TEXT,
        FOREIGN KEY (subject_id) REFERENCES subjects(id)
      )
    ''');

    // Questions table
    await db.execute('''
      CREATE TABLE questions (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        chapter_id      INTEGER NOT NULL,
        exercise_name   TEXT NOT NULL,
        question_number TEXT NOT NULL,
        question_text   TEXT NOT NULL,
        question_type   TEXT NOT NULL DEFAULT 'short',
        FOREIGN KEY (chapter_id) REFERENCES chapters(id)
      )
    ''');

    // Solutions table
    await db.execute('''
      CREATE TABLE solutions (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id     INTEGER NOT NULL UNIQUE,
        solution_text   TEXT NOT NULL,
        diagram_svg     TEXT,
        difficulty      TEXT DEFAULT 'medium',
        FOREIGN KEY (question_id) REFERENCES questions(id)
      )
    ''');

    // Previous year papers
    await db.execute('''
      CREATE TABLE papers (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        board_id    INTEGER NOT NULL,
        class_id    INTEGER NOT NULL,
        subject_id  INTEGER,
        year        INTEGER NOT NULL,
        month       TEXT,
        pdf_asset   TEXT NOT NULL,
        FOREIGN KEY (board_id)   REFERENCES boards(id),
        FOREIGN KEY (class_id)   REFERENCES classes(id),
        FOREIGN KEY (subject_id) REFERENCES subjects(id)
      )
    ''');

    // Quiz questions (MCQ)
    await db.execute('''
      CREATE TABLE quiz_questions (
        id             INTEGER PRIMARY KEY AUTOINCREMENT,
        chapter_id     INTEGER NOT NULL,
        question_text  TEXT NOT NULL,
        option_a       TEXT NOT NULL,
        option_b       TEXT NOT NULL,
        option_c       TEXT NOT NULL,
        option_d       TEXT NOT NULL,
        correct_option TEXT NOT NULL,
        explanation    TEXT,
        FOREIGN KEY (chapter_id) REFERENCES chapters(id)
      )
    ''');

    // Student progress (local only)
    await db.execute('''
      CREATE TABLE progress (
        id              INTEGER PRIMARY KEY AUTOINCREMENT,
        subject_id      INTEGER NOT NULL,
        chapter_id      INTEGER NOT NULL,
        completed       INTEGER DEFAULT 0,
        quiz_score      INTEGER DEFAULT 0,
        last_accessed   TEXT,
        FOREIGN KEY (subject_id) REFERENCES subjects(id),
        FOREIGN KEY (chapter_id) REFERENCES chapters(id)
      )
    ''');

    // Full text search index
    await db.execute('''
      CREATE VIRTUAL TABLE search_index USING fts5(
        type,
        title,
        content,
        ref_id UNINDEXED
      )
    ''');

    // Seed initial data
    await _seedData(db);
  }

  Future<void> _seedData(Database db) async {
    // Insert boards
    final sscId = await db.insert('boards', {
      'name': 'SSC Maharashtra',
      'code': 'SSC'
    });
    final cbseId = await db.insert('boards', {
      'name': 'CBSE',
      'code': 'CBSE'
    });

    // Insert classes for SSC
    for (int cls in [8, 9, 10]) {
      await db.insert('classes', {
        'board_id': sscId,
        'class_number': cls,
      });
    }

    // Insert classes for CBSE
    for (int cls in [8, 9, 10]) {
      await db.insert('classes', {
        'board_id': cbseId,
        'class_number': cls,
      });
    }
  }

  // ── GENERIC QUERY HELPERS ──────────────────

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final db = await database;
    return db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return db.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return db.update(table, data,
        where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return db.delete(table,
        where: where, whereArgs: whereArgs);
  }

  // ── SEARCH ────────────────────────────────

  Future<List<Map<String, dynamic>>> search(String query) async {
    final db = await database;
    return db.rawQuery(
      "SELECT * FROM search_index WHERE search_index MATCH ? ORDER BY rank",
      [query],
    );
  }

  // ── PROGRESS ──────────────────────────────

  Future<void> markChapterComplete(
      int subjectId, int chapterId) async {
    await update(
      'progress',
      {
        'completed': 1,
        'last_accessed': DateTime.now().toIso8601String(),
      },
      where: 'subject_id = ? AND chapter_id = ?',
      whereArgs: [subjectId, chapterId],
    );
  }

  Future<Map<String, dynamic>?> getProgress(
      int subjectId, int chapterId) async {
    final results = await query(
      'progress',
      where: 'subject_id = ? AND chapter_id = ?',
      whereArgs: [subjectId, chapterId],
    );
    return results.isEmpty ? null : results.first;
  }
}
