import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class DatabaseService {
  DatabaseService._();
  static final DatabaseService instance = DatabaseService._();

  static Database? _db;
  static const _dbName = 'memowave.db';
  static const _dbVersion = 2;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        category TEXT NOT NULL DEFAULT 'General',
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    await db.execute('CREATE INDEX idx_notes_updated ON notes(updated_at DESC)');
  }

  Future<void> _onUpgrade(Database db, int oldV, int newV) async {
    if (oldV < 2) {
      await db.execute("ALTER TABLE notes ADD COLUMN category TEXT NOT NULL DEFAULT 'General'");
    }
  }

  Future<List<Note>> getAll() async {
    final db = await database;
    final rows = await db.query('notes', orderBy: 'updated_at DESC');
    return rows.map(Note.fromMap).toList();
  }

  Future<List<Note>> search(String query) async {
    final db = await database;
    final q = '%${query.toLowerCase()}%';
    final rows = await db.rawQuery(
      'SELECT * FROM notes WHERE lower(title) LIKE ? OR lower(body) LIKE ? ORDER BY updated_at DESC',
      [q, q],
    );
    return rows.map(Note.fromMap).toList();
  }

  Future<List<Note>> byCategory(String category) async {
    final db = await database;
    final rows = await db.query(
      'notes',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'updated_at DESC',
    );
    return rows.map(Note.fromMap).toList();
  }

  Future<List<String>> categories() async {
    final db = await database;
    final rows = await db.rawQuery('SELECT DISTINCT category FROM notes ORDER BY category');
    return rows.map((r) => r['category'] as String).toList();
  }

  Future<void> insert(Note note) async {
    final db = await database;
    await db.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> update(Note note) async {
    final db = await database;
    await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> delete(String id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
