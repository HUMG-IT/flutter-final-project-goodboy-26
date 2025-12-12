// lib/models/note.dart
import 'package:uuid/uuid.dart'; 

class Note {
  String id;
  String title;
  String content;
  bool isCompleted;

  Note({
    String? id,
    this.title = '',
    this.content = '',
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4(); 

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        content: json['content'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'isCompleted': isCompleted,
      };
}