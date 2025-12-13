import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  final _db = Localstore.instance;
  final String _collection = 'notes';
  List<Note> _notes = [];

  bool isTestMode;

  List<Note> get notes => _notes;

  NoteProvider({this.isTestMode = false}) {
    if (!isTestMode) {
      loadNotes();
    } else {
      debugPrint('NoteProvider: running in test mode, skip loadNotes()');
    }
  }

  void testAdd(Note note) {
    _notes.add(note);
    _sortByDate();
    notifyListeners();
  }


  Future<void> loadNotes() async {
    debugPrint('loadNotes called; isTestMode=$isTestMode');
    try {
      if (isTestMode) return;

      final data = await _db.collection(_collection).get();
      if (data != null) {
        _notes = data.values
            .map((json) => Note.fromJson(json))
            .toList();
        _sortByDate();
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
      if (!isTestMode) {
        await _db.collection(_collection).doc(note.id).set(note.toJson());
      }
      _notes.add(note);
      _sortByDate(); // 👈
      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi thêm note: $e');
      _showError('Không thể thêm ghi chú. Vui lòng thử lại!');
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      if (!isTestMode) {
        await _db.collection(_collection).doc(note.id).set(note.toJson());
      }

      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] = note;
        _sortByDate(); // 👈
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi cập nhật note: $e');
      _showError('Không thể cập nhật ghi chú!');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      if (!isTestMode) {
        await _db.collection(_collection).doc(id).delete();
      }

      _notes.removeWhere((n) => n.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi xóa note: $e');
      _showError('Không thể xóa ghi chú!');
    }
  }

  void _sortByDate() {
    _notes.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt), // mới nhất lên đầu
    );
  }

  void _showError(String message) {
    debugPrint(message);
  }
}
