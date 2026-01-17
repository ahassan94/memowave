import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../services/notes_provider.dart';
import '../widgets/note_tile.dart';
import 'edit_note_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final TextEditingController _searchCtl = TextEditingController();
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().load();
    });
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  void _openEditor([Note? note]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => EditNoteScreen(note: note)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();
    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchCtl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search notes...',
                  border: InputBorder.none,
                ),
                onChanged: (v) => provider.setQuery(v),
              )
            : const Text('memowave'),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _searching = !_searching;
                if (!_searching) {
                  _searchCtl.clear();
                  provider.setQuery('');
                }
              });
            },
          ),
        ],
      ),
      body: provider.loading && provider.notes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : provider.notes.isEmpty
              ? const Center(child: Text('No notes yet. Tap + to add one.'))
              : ListView.builder(
                  itemCount: provider.notes.length,
                  itemBuilder: (ctx, i) {
                    final n = provider.notes[i];
                    return Dismissible(
                      key: ValueKey(n.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => provider.remove(n.id),
                      child: NoteTile(
                        note: n,
                        onTap: () => _openEditor(n),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
