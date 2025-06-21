import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  const NoteTile({super.key, required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final preview = note.body.replaceAll('\n', ' ');
    final date = DateFormat.MMMd().format(note.updatedAt);
    return ListTile(
      title: Text(
        note.title.isEmpty ? '(untitled)' : note.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(preview, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      onTap: onTap,
    );
  }
}
