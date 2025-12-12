
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/note_provider.dart';
import 'note_detail_screen.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _NoteListContent();
  }
}

class _NoteListContent extends StatelessWidget {
  const _NoteListContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chú của tôi'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade600,
        foregroundColor: Colors.white,
        elevation: 10,
        shadowColor: Colors.deepPurple.withOpacity(0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),

      body: provider.notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 100, color: Colors.deepPurple.shade200),
                  const SizedBox(height: 24),
                  Text(
                    'Chưa có ghi chú nào',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nhấn nút + để tạo mới',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: provider.notes.length,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemBuilder: (context, index) {
                final note = provider.notes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: note.isCompleted
                          ? [Colors.green.shade50, Colors.green.shade100]
                          : [Colors.deepPurple.shade50, Colors.deepPurple.shade100],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundColor: note.isCompleted ? Colors.green : Colors.deepPurple,
                      child: Icon(
                        note.isCompleted ? Icons.check_circle : Icons.edit_note,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    title: Text(
                      note.title.isEmpty ? '(Không có tiêu đề)' : note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                      ),
                    ),
                    trailing: Icon(
                      note.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: note.isCompleted ? Colors.green.shade700 : Colors.grey,
                      size: 32,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NoteDetailScreen(note: note),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NoteDetailScreen()),
          );
        },
        backgroundColor: Colors.deepPurple.shade600,
        elevation: 10,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}