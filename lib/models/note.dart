import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final int color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.color,
  });

  factory Note.fromDoc(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      updatedAt: (data['updated_at'] as Timestamp).toDate(),
      userId: data['user_id'] as String,
      color: data['color'] ?? 0xFF2196F3,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
      'color': color,
    };
  }

  String get formattedCreated => _formatDate(createdAt, isRelative: false);
  String get formattedUpdated => _formatDate(updatedAt, isRelative: true);

  String _formatDate(DateTime date, {required bool isRelative}) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (isRelative) {
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } else {
      return DateFormat('MMM d, yyyy').format(date); // "Jan 7"
    }
  }
}
