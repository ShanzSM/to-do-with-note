import 'package:todo_app/model/todo_model.dart';

class ToDoService {
  static final ToDoService _instance = ToDoService._internal();
  factory ToDoService() => _instance;
  ToDoService._internal();

  final List<ToDoModel> _tasks = [
    ToDoModel(
      title: "Finish Hi-Fi design of notes mobile app",
      deadline: "Today",
    ),
    ToDoModel(title: "Finish Prototype notes mobile app", deadline: "Today"),
    ToDoModel(
      title: "Finish Home notes mobile app Using flutter and dart",
      deadline: "Tomorrow",
    ),
    ToDoModel(title: "Another pending task", deadline: "This Week"),
    ToDoModel(title: "Old pending task", deadline: "Next Week"),
  ];

  List<ToDoModel> get tasks => List.unmodifiable(_tasks);

  void addTask(ToDoModel task) {
    _tasks.insert(0, task);
  }

  void removeTask(ToDoModel task) {
    _tasks.remove(task);
  }

  void toggleComplete(ToDoModel task) {
    final idx = _tasks.indexOf(task);
    if (idx != -1) {
      _tasks[idx] = ToDoModel(
        title: task.title,
        deadline: task.deadline,
        isCompleted: !task.isCompleted,
      );
    }
  }
}
