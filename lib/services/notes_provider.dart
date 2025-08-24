import 'package:flutter/foundation.dart';

import '../models/note.dart';
import 'database_service.dart';

class NotesProvider extends ChangeNotifier {
  final DatabaseService _db;
  NotesProvider({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  List<Note> _notes = [];
  String _query = '';
  String? _categoryFilter;
  bool _loading = false;

  List<Note> get notes => _notes;
  String get query => _query;
  String? get categoryFilter => _categoryFilter;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    if (_query.isNotEmpty) {
      _notes = await _db.search(_query);
    } else if (_categoryFilter != null) {
      _notes = await _db.byCategory(_categoryFilter!);
    } else {
      _notes = await _db.getAll();
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> setQuery(String q) async {
    _query = q;
    await load();
  }

  Future<void> setCategory(String? c) async {
    _categoryFilter = c;
    await load();
  }

  Future<void> add(Note n) async {
    await _db.insert(n);
    await load();
  }

  Future<void> update(Note n) async {
    await _db.update(n);
    await load();
  }

  Future<void> remove(String id) async {
    await _db.delete(id);
    await load();
  }
}
