import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/notes_provider.dart';
import '../widgets/note_tile.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('memowave')),
      body: provider.loading && provider.notes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.notes.length,
              itemBuilder: (ctx, i) {
                final n = provider.notes[i];
                return Dismissible(
                  key: ValueKey(n.id),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => provider.remove(n.id),
                  child: NoteTile(note: n, onTap: () {}),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
