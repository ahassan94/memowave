import 'package:flutter_test/flutter_test.dart';
import 'package:memowave/models/note.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late Database db;

  setUp(() async {
    db = await databaseFactory.openDatabase(inMemoryDatabasePath);
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
  });

  tearDown(() async {
    await db.close();
  });

  test('insert then select returns the note', () async {
    final n = Note(title: 'hello', body: 'world');
    await db.insert('notes', n.toMap());
    final rows = await db.query('notes');
    expect(rows.length, 1);
    expect(rows.first['title'], 'hello');
  });

  test('search by title LIKE', () async {
    await db.insert('notes', Note(title: 'shopping', body: 'milk').toMap());
    await db.insert('notes', Note(title: 'work plan', body: 'Q3').toMap());
    final rows = await db.rawQuery(
        'SELECT * FROM notes WHERE lower(title) LIKE ?', ['%shop%']);
    expect(rows.length, 1);
    expect(rows.first['title'], 'shopping');
  });

  test('delete removes row', () async {
    final n = Note(title: 'gone', body: 'soon');
    await db.insert('notes', n.toMap());
    await db.delete('notes', where: 'id = ?', whereArgs: [n.id]);
    final rows = await db.query('notes');
    expect(rows, isEmpty);
  });

  test('filter by category', () async {
    await db.insert('notes', Note(title: 'a', body: '', category: 'Work').toMap());
    await db.insert('notes', Note(title: 'b', body: '', category: 'Personal').toMap());
    final work = await db.query('notes', where: 'category = ?', whereArgs: ['Work']);
    expect(work.length, 1);
  });
}
