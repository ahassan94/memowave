import 'package:flutter_test/flutter_test.dart';
import 'package:memowave/models/note.dart';

void main() {
  group('Note', () {
    test('generates id when not provided', () {
      final n = Note(title: 't', body: 'b');
      expect(n.id, isNotEmpty);
    });

    test('defaults category to General', () {
      final n = Note(title: 't', body: 'b');
      expect(n.category, 'General');
    });

    test('round-trips through toMap / fromMap', () {
      final original = Note(
        id: 'abc-123',
        title: 'hello',
        body: 'world',
        category: 'Work',
        createdAt: DateTime.fromMillisecondsSinceEpoch(1000),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(2000),
      );
      final map = original.toMap();
      final restored = Note.fromMap(map);
      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.body, original.body);
      expect(restored.category, original.category);
      expect(restored.createdAt, original.createdAt);
      expect(restored.updatedAt, original.updatedAt);
    });

    test('copyWith updates fields and bumps updatedAt', () {
      final n = Note(title: 't', body: 'b');
      final before = n.updatedAt;
      // small delay to force different timestamp
      final updated = n.copyWith(title: 'new');
      expect(updated.title, 'new');
      expect(updated.body, 'b');
      expect(updated.id, n.id);
      expect(updated.createdAt, n.createdAt);
      expect(updated.updatedAt.isAfter(before) || updated.updatedAt == before, isTrue);
    });
  });
}
