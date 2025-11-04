import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();
  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  // 🚨 VULNERABILITY #14: Unencrypted SQLite Database
  // OWASP: M9 - Insecure Data Storage
  // Risk: Notes stored in plain text, can be read directly from database file
  // Solution: Use encrypted database (e.g., sqflite_sqlcipher)
  // Reference: https://owasp.org/www-project-mobile-top-10/2023-risks/
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    print('📂 Database path: $path');
    print('⚠️  Database is NOT encrypted!');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE notes (
        id $idType,
        title $textType,
        content $textType,
        createdAt $textType,
        userId $textType
      )
    ''');

    print('✅ Database table created');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  Future<List<Note>> readAllNotes(String userId) async {
    final db = await instance.database;
    const orderBy = 'createdAt DESC';

    final result = await db.query(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: orderBy,
    );

    return result.map((json) => Note.fromMap(json)).toList();
  }

  // 🚨 VULNERABILITY #7: SQL Injection
  // OWASP: M4 - Insufficient Input/Output Validation
  // Risk: Attacker can inject SQL commands through search query
  // Solution: Use parameterized queries with ? placeholders
  // Reference: https://docs.talsec.app/appsec-articles/articles/owasp-top-10-for-flutter-m4-insufficient-input-output-validation-in-flutter
  Future<List<Note>> searchNotes(String searchQuery, String userId) async {
    final db = await instance.database;

    print('🔍 Searching for: $searchQuery');
    print('⚠️  Using vulnerable SQL concatenation!');

    // VULNERABLE: Direct string concatenation allows SQL injection
    // Example attack: ' OR '1'='1' --
    // This would return all notes regardless of userId
    final result = await db.rawQuery(
      "SELECT * FROM notes WHERE userId = '$userId' AND (title LIKE '%$searchQuery%' OR content LIKE '%$searchQuery%') ORDER BY createdAt DESC"
    );

    print('📊 Found ${result.length} results');

    return result.map((json) => Note.fromMap(json)).toList();
  }

  Future<int> update(Note note) async {
    final db = await instance.database;

    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllNotes(String userId) async {
    final db = await instance.database;

    return await db.delete(
      'notes',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

// Extension to help with copying Note objects
extension NoteCopy on Note {
  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
    String? userId,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
    );
  }
}
