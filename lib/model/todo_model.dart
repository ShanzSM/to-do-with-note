class ToDoModel {
  final String title;
  final String deadline;
  final bool isCompleted;

  ToDoModel({
    required this.title,
    required this.deadline,
    this.isCompleted = false,
  });
}
// need to remove