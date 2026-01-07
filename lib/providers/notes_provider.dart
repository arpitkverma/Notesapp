import 'package:flutter/foundation.dart';

import '../models/note.dart';
import '../services/notes_service.dart';

class NotesProvider extends ChangeNotifier {
  final String? userId;
  final NotesService _service = NotesService();

  List<Note> _allNotes = [];
  String _searchQuery = '';

  NotesProvider(this.userId) {
    if (userId != null) {
      _service
          .notesStream(userId!)
          .listen(
            (notes) {
              _allNotes = notes;
              notifyListeners();
            },
            onError: (e) {
              print(e);
            },
          );
    }
  }

  void copyFrom(NotesProvider? previous) {
    if (previous != null) {
      _allNotes = previous._allNotes;
      _searchQuery = previous._searchQuery;
    }
  }

  List<Note> get notes {
    if (_searchQuery.isEmpty) return _allNotes;
    final q = _searchQuery.toLowerCase();
    return _allNotes
        .where((n) => n.title.toLowerCase().contains(q))
        .toList(); // client-side search by title.[web:23]
  }

  String get searchQuery => _searchQuery;

  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  Future<void> addNote(String title, String content, int color) async {
    if (userId == null) return;
    try {
      await _service.createNote(
        userId: userId!,
        title: title,
        content: content,
        color: color,
      );
    } catch (e) {
      if (e.toString().contains('No internet')) {
        // Silent - Firestore handles offline
        print('Offline save: $e');
      } else {
        rethrow;
      }
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      _service.updateNote(note);
    } catch (e) {
      if (e.toString().contains('No internet')) {
        // Silent - Firestore handles offline
        print('Offline save: $e');
      } else {
        rethrow;
      }
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      _service.deleteNote(id);
    } catch (e) {
      if (e.toString().contains('No internet')) {
        // Silent - Firestore handles offline
        print('Offline save: $e');
      } else {
        rethrow;
      }
    }
  }
}
