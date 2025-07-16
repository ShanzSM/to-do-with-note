import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/model/todo_model.dart';

class ToDoService {
  final _firestore = FirebaseFirestore.instance;

  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  // Add a new task
  Future<void> addTask(ToDoModel task) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .doc(task.id)
        .set(task.toMap());
  }

  // Load all tasks for the current user
  Future<List<ToDoModel>> loadTasks() async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .get();
    return snapshot.docs.map((doc) => ToDoModel.fromMap(doc.data())).toList();
  }

  // Remove a task by id
  Future<void> removeTask(String taskId) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  // Toggle completion status of a task
  Future<void> toggleComplete(ToDoModel task) async {
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .doc(task.id)
        .update({'isCompleted': !task.isCompleted});
  }

  // Get tasks by deadline (e.g., 'Today', 'Tomorrow', etc.)
  Future<List<ToDoModel>> getTasksByDeadline(String deadline) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('tasks')
        .where('deadline', isEqualTo: deadline)
        .get();
    return snapshot.docs.map((doc) => ToDoModel.fromMap(doc.data())).toList();
  }
}
