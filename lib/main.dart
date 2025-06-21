import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/notes_provider.dart';
import 'screens/notes_list_screen.dart';

void main() {
  runApp(const MemowaveApp());
}

class MemowaveApp extends StatelessWidget {
  const MemowaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotesProvider(),
      child: MaterialApp(
        title: 'memowave',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const NotesListScreen(),
      ),
    );
  }
}
