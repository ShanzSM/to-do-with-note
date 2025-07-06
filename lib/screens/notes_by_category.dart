import 'package:flutter/material.dart';
import 'package:todo_app/app/router.dart';
import 'package:todo_app/model/note_model.dart';
import 'package:todo_app/service/note_service.dart';
import 'package:todo_app/widgets/note_category_card.dart';
import 'package:todo_app/screens/add_note_page.dart';
import 'package:go_router/go_router.dart';

class NotesByCategory extends StatefulWidget {
  final String category;
  const NotesByCategory({super.key, required this.category});

  @override
  State<NotesByCategory> createState() => _NotesByCategoryState();
}

class _NotesByCategoryState extends State<NotesByCategory> {
  final NoteService noteService = NoteService();
  List<Note> noteList = [];

  @override
  void initState() {
    super.initState();
    _loadNotesByCategory();
  }

  //Load all Notes By category
  Future<void> _loadNotesByCategory() async {
    noteList = await noteService.getNotesByCategoryName(widget.category);
    setState(() {
      // Notes loaded successfully
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.category,
                style: TextStyle(color: Colors.white, fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.push("/notes");
              },
            ),
          ],
        ),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 2,
          childAspectRatio: 7 / 11,
        ),
        itemCount: noteList.length,
        itemBuilder: (BuildContext context, int index) {
          final note = noteList[index];
          return NoteCategoryCard(
            noteTitle: note.title,
            noteContent: note.content,
            removeNote: () async {
              await noteService.deleteNote(note.id);
              await _loadNotesByCategory();
            },
            editNote: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNotePage(
                    category: note.category,
                    initialTitle: note.title,
                    initialContent: note.content,
                    noteId: note.id,
                  ),
                ),
              );
              if (result == true) {
                await _loadNotesByCategory();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(
                category: widget.category,
                initialTitle: '',
                initialContent: '',
                noteId: '',
              ),
            ),
          );
          if (result == true) {
            await _loadNotesByCategory();
          }
        },
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        backgroundColor: Color(0xFF2A2A2A),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
