import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/note.dart';
import '../providers/note_provider.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note? note;
  const NoteDetailScreen({super.key, this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late bool _isCompleted;
  late DateTime _createdAt;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _isCompleted = widget.note?.isCompleted ?? false;
    _createdAt = widget.note?.createdAt ?? DateTime.now(); // 👈
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _createdAt,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_createdAt),
    );

    if (time == null) return;

    setState(() {
      _createdAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _saveNote() {
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }

    final id = widget.note?.id ?? const Uuid().v4();
    final note = Note(
      id: id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      isCompleted: _isCompleted,
      createdAt: _createdAt, // 👈 lưu ngày giờ
    );

    final provider = Provider.of<NoteProvider>(context, listen: false);
    if (widget.note == null) {
      provider.addNote(note);
    } else {
      provider.updateNote(note);
    }
    Navigator.pop(context);
  }

  void _deleteNote() {
    if (widget.note != null) {
      Provider.of<NoteProvider>(context, listen: false)
          .deleteNote(widget.note!.id);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.note == null ? 'Ghi chú mới' : 'Chỉnh sửa',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          if (widget.note != null)
            IconButton(
              icon: const Icon(Icons.delete, size: 28),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text('Xóa ghi chú?',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    content: const Text('Hành động này không thể hoàn tác.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Hủy')),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _deleteNote();
                        },
                        child: const Text('Xóa',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            TextField(
              controller: _titleController,
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: 'Tiêu đề ghi chú...',
                hintStyle:
                    TextStyle(color: Colors.grey.shade400, fontSize: 28),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: _pickDateTime,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        color: Colors.deepPurple),
                    const SizedBox(width: 12),
                    Text(
                      '${_createdAt.day}/${_createdAt.month}/${_createdAt.year} '
                      '${_createdAt.hour.toString().padLeft(2, '0')}:'
                      '${_createdAt.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(fontSize: 18, height: 1.6),
                decoration: InputDecoration(
                  hintText: 'Nội dung ghi chú...',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade400, fontSize: 18),
                  border: InputBorder.none,
                ),
              ),
            ),

            if (widget.note != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isCompleted,
                      activeColor: Colors.green,
                      onChanged: (v) =>
                          setState(() => _isCompleted = v ?? false),
                    ),
                    const Text('Đánh dấu đã hoàn thành',
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // ======================
            // SAVE BUTTON
            // ======================
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _saveNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple.shade600,
                  elevation: 10,
                  shadowColor: Colors.deepPurple.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  widget.note == null ? 'Tạo ghi chú' : 'Lưu thay đổi',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
