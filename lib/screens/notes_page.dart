import 'package:flutter/material.dart';
import 'package:todo_app/app/router.dart';
import 'package:todo_app/model/note_model.dart';
import 'package:todo_app/service/note_service.dart';
import 'package:todo_app/widgets/notes_card.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_router/go_router.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> allNotes = [];
  Map<String, List<Note>> notesWithCategory = {};
  String? draftCategory;

  @override
  void initState() {
    super.initState();
    _checkIfUserNewAndCreateinitialNotes();
  }

  final NoteService noteService = NoteService();
  //check weather the user is new
  void _checkIfUserNewAndCreateinitialNotes() async {
    final bool isNewUser = await noteService.isNewUser();

    //if the user is new create the initial notes
    if (isNewUser) {
      await noteService.createInitialNotes();
    }

    //Load the Nots
    await _loadNotes();
  }

  //Load the notes
  Future<void> _loadNotes() async {
    final List<Note> loadedNotes = await noteService.loadNotes();
    final Map<String, List<Note>> notesByCategory = noteService
        .getNotesByCategoryMap(loadedNotes);
    setState(() {
      allNotes = loadedNotes;
      notesWithCategory = notesByCategory;
    });
  }

  void _showAddCategoryDialog() async {
    TextEditingController controller = TextEditingController();
    setState(() {
      draftCategory = "Drafts";
    });
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF232323),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add New Category',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Category name',
                  hintStyle: TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Color(0xFF2A2A2A),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        draftCategory = null;
                      });
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () async {
                      if (controller.text.trim().isNotEmpty) {
                        // Add the new category (empty note list)
                        setState(() {
                          notesWithCategory[controller.text.trim()] = [];
                          draftCategory = null;
                        });
                        Navigator.of(context).pop();
                        // Navigate to the new category page
                        context.push(
                          "/category",
                          extra: controller.text.trim(),
                        );
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
    setState(() {
      draftCategory = null;
    });
  }

  Future<void> _editCategory(String oldCategory) async {
    TextEditingController controller = TextEditingController(text: oldCategory);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232323),
          title: const Text(
            'Edit Category',
            style: TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Category name',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.of(context).pop(controller.text.trim());
                }
              },

              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
    if (newName != null && newName != oldCategory && newName.isNotEmpty) {
      // Update all notes in this category in Firestore
      final notes = notesWithCategory[oldCategory] ?? [];
      for (final note in notes) {
        final updatedNote = Note(
          id: note.id,
          title: note.title,
          category: newName,
          content: note.content,
          date: note.date,
        );
        await noteService.deleteNote(note.id);
        await noteService.addNote(updatedNote);
      }
      await _loadNotes();
    }
  }

  Future<void> _deleteCategory(String category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF232323),
          title: const Text(
            'Delete Category',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),

          content: const Text(
            'Are you sure you want to delete this category and all its notes?',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      final notes = notesWithCategory[category] ?? [];
      for (final note in notes) {
        await noteService.deleteNote(note.id);
      }
      await _loadNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E1E),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go("/home");
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        backgroundColor: Color(0xFF2A2A2A),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notes',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            const SizedBox(height: 30),
            allNotes.isEmpty && draftCategory == null
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Text(
                        "No notes available , click on the + button to add a new note",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio:
                          (MediaQuery.of(context).size.width /
                                  (MediaQuery.of(context).size.height * 0.20))
                              .clamp(0.7, 1.3),
                    ),
                    itemCount:
                        notesWithCategory.length +
                        (draftCategory != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (draftCategory != null && index == 0) {
                        // Show draft dotted border card
                        return DottedBorder(
                          color: Colors.white54,
                          strokeWidth: 1.5,
                          borderType: BorderType.RRect,
                          radius: Radius.circular(15),
                          dashPattern: [6, 4],
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF232323),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Drafts',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '0 notes',
                                  style: TextStyle(color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final realIndex = draftCategory != null
                          ? index - 1
                          : index;
                      return NotesCard(
                        noteCategory: notesWithCategory.keys.elementAt(
                          realIndex,
                        ),
                        noOfNotes: notesWithCategory.values
                            .elementAt(realIndex)
                            .length,
                        onTap: () {
                          context.push(
                            "/category",
                            extra: notesWithCategory.keys.elementAt(realIndex),
                          );
                        },
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          color: const Color(0xFF232323),
                          onSelected: (value) async {
                            final category = notesWithCategory.keys.elementAt(
                              realIndex,
                            );
                            if (value == 'edit') {
                              await _editCategory(category);
                            } else if (value == 'delete') {
                              await _deleteCategory(category);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
