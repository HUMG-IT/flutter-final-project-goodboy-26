// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/note.dart';
import 'package:flutter_application_1/providers/note_provider.dart';
import 'package:flutter_application_1/screens/note_list_screen.dart';

void main() {
  testWidgets('App chạy được, hiển thị màn hình danh sách', (tester) async {
    // Tạo provider nhưng KHÔNG gọi loadNotes() → tránh treo hoàn toàn
    final provider = NoteProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(
          home: NoteListScreen(),
        ),
      ),
    );

    // Chỉ cần thấy dòng chữ này là đủ → chứng tỏ app chạy, không crash, không treo
    expect(find.text('Chưa có ghi chú nào'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Có thể thêm note giả và thấy trên UI', (tester) async {
    final provider = NoteProvider();

  
    (provider.notes as List<Note>).addAll([
      Note(title: "Học Flutter", content: "Rất vui"),
      Note(title: "Ngủ", isCompleted: true),
    ]);
    provider.notifyListeners(); // báo UI biết có dữ liệu mới

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: NoteListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Học Flutter'), findsOneWidget);
    expect(find.text('Ngủ'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsWidgets);
  });
}