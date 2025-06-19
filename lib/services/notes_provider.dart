import 'package:flutter/foundation.dart';

import '../models/note.dart';
import 'database_service.dart';

class NotesProvider extends ChangeNotifier {
  final DatabaseService _db;
  NotesProvider({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  List<Note> _notes = [];
  bool _loading = false;

  List<Note> get notes => _notes;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _notes = await _db.getAll();
    _loading = false;
    notifyListeners();
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
