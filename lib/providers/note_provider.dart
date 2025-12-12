
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  final _db = Localstore.instance;
  final String _collection = 'notes';
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  NoteProvider() {
    loadNotes(); // tự động load khi khởi tạo
  }

  Future<void> loadNotes() async {
    try {
      final data = await _db.collection(_collection).get();
      if (data != null) {
        _notes = data.values.map((json) => Note.fromJson(json)).toList();
      } else {
        _notes = [];
      }
    } catch (e) {
      _notes = [];
      debugPrint('Lỗi đọc dữ liệu localstore: $e');
    }
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    try {
      await _db.collection(_collection).doc(note.id).set(note.toJson());
      await loadNotes(); // reload để cập nhật danh sách
    } catch (e) {
      debugPrint('Lỗi thêm note: $e');
      _showError('Không thể thêm ghi chú. Vui lòng thử lại!');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _db.collection(_collection).doc(note.id).set(note.toJson());
      await loadNotes();
    } catch (e) {
      debugPrint('Lỗi cập nhật note: $e');
      _showError('Không thể cập nhật ghi chú!');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _db.collection(_collection).doc(id).delete();
      await loadNotes();
    } catch (e) {
      debugPrint('Lỗi xóa note: $e');
      _showError('Không thể xóa ghi chú!');
    }
  }

  // Hàm hiển thị thông báo lỗi (gọi từ UI nếu cần)
  void _showError(String message) {
    // Anh có thể gọi hàm này từ màn hình nếu muốn hiện SnackBar
    debugPrint(message);
  }
}