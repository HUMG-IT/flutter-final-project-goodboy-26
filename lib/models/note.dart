// lib/models/note.dart
import 'package:uuid/uuid.dart';

class Note {
  String id;
  String title;
  String content;
  bool isCompleted;
  DateTime createdAt;

  Note({
    String? id,
    this.title = '',
    this.content = '',
    this.isCompleted = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
      };
}
