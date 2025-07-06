import 'package:flutter/material.dart';
import 'package:todo_app/model/note_model.dart';
import 'package:todo_app/service/note_service.dart';
import 'package:go_router/go_router.dart';

class AddNotePage extends StatefulWidget {
  final String category;
  final String initialTitle;
  final String initialContent;
  final String noteId;

  const AddNotePage({
    super.key,
    required this.category,
    required this.initialTitle,
    required this.initialContent,
    required this.noteId,
  });

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final NoteService noteService = NoteService();

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF1E1E1E);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
          mouseCursor: SystemMouseCursors.click,
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Add Title',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Add content',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_titleController.text.isNotEmpty) {
            final note = Note(
              title: _titleController.text,
              content: _contentController.text,
              category: widget.category,
              date: DateTime.now(),
            );
            await noteService.addNote(note);
            if (mounted) {
              Navigator.pop(context, true);
            }
          }
        },
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        child: Icon(Icons.check, color: Colors.white, size: 30),
      ),
    );
  }
}
