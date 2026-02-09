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
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        preview,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(date, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(note.category, style: const TextStyle(fontSize: 10)),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
