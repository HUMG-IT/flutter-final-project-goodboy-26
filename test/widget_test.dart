import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_final_project_goodboy_26/models/note.dart';
import 'package:flutter_final_project_goodboy_26/providers/note_provider.dart';
import 'package:flutter_final_project_goodboy_26/screens/note_list_screen.dart';

void main() {
  testWidgets('App chạy được, hiển thị màn hình danh sách', (tester) async {
    final provider = NoteProvider(isTestMode: true);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(
          home: NoteListScreen(),
        ),
      ),
    );

    expect(find.text('Chưa có ghi chú nào'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Có thể thêm note giả và thấy trên UI', (tester) async {
    final provider = NoteProvider(isTestMode: true);

    provider.testAdd(Note(title: "Học Flutter", content: "Rất vui"));
    provider.testAdd(Note(title: "Ngủ", isCompleted: true));

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
