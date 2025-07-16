import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/model/note_model.dart';

class NoteService {
  final _firestore = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // Add a new note
  Future<void> addNote(Note note) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .doc(note.id)
        .set(note.toMap());
  }

  // Load all notes for the current user
  Future<List<Note>> loadNotes() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .get();
    return snapshot.docs.map((doc) => Note.fromMap(doc.data())).toList();
  }

  // Update a note
  Future<void> updateNote(Note note) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .doc(note.id)
        .update(note.toMap());
  }

  // Delete a note by id
  Future<void> deleteNote(String noteId) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  // Group notes by category
  Map<String, List<Note>> getNotesByCategoryMap(List<Note> allNotes) {
    final Map<String, List<Note>> notesByCategory = {};
    for (final note in allNotes) {
      if (notesByCategory.containsKey(note.category)) {
        notesByCategory[note.category]!.add(note);
      } else {
        notesByCategory[note.category] = [note];
      }
    }
    return notesByCategory;
  }

  // Get notes by category name
  Future<List<Note>> getNotesByCategoryName(String category) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .where('category', isEqualTo: category)
        .get();
    return snapshot.docs.map((doc) => Note.fromMap(doc.data())).toList();
  }

  // Check if user is new (no notes)
  Future<bool> isNewUser() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('notes')
        .limit(1)
        .get();
    return snapshot.docs.isEmpty;
  }

  // Create initial notes for new user (optional, can be empty)
  Future<void> createInitialNotes() async {
    // You can add default notes here if needed, or leave empty
  }
}
