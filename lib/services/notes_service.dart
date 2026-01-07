import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/note.dart';

class NotesService {
  final _db = FirebaseFirestore.instance;
  static const _collection = 'notes';
  final Connectivity _connectivity = Connectivity();

  Future<bool> _ensureOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);
  }

  Stream<List<Note>> notesStream(String userId) {
    return _db
        .collection(_collection)
        .where('user_id', isEqualTo: userId)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Note.fromDoc).toList());
  }

  Future<void> createNote({
    required String userId,
    required String title,
    required String content,
    required int color,
  }) async {
    final online = await _ensureOnline();
    if (!online) {
      throw Exception('No internet - saved offline');
    }
    final now = DateTime.now();
    await _db.collection(_collection).add({
      'title': title,
      'content': content,
      'created_at': now,
      'updated_at': now,
      'user_id': userId,
      'color': color,
    });
  }

  Future<void> updateNote(Note note) async {
    final online = await _ensureOnline();
    if (!online) throw Exception('No internet - changes saved offline');
    await _db.collection(_collection).doc(note.id).update({
      'title': note.title,
      'content': note.content,
      'color': note.color,
      'updated_at': DateTime.now(),
    });
  }

  Future<void> deleteNote(String id) async {
    final online = await _ensureOnline();
    if (!online) throw Exception('No internet - deleted offline');
    await _db.collection(_collection).doc(id).delete();
  }
}
