// lib/models/note.dart
import 'package:uuid/uuid.dart'; // để tạo id tự động

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
  }) : id = id ?? const Uuid().v4(); // tự động tạo id nếu chưa có

  // BẮT BUỘC PHẢI CÓ 2 HÀM NÀY KHI DÙNG LOCALSTORE
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