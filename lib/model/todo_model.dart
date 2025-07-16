import 'package:uuid/uuid.dart';

class ToDoModel {
  final String id;
  final String title;
  final String deadline;
  final bool isCompleted;
  final DateTime createdAt;

  ToDoModel({
    String? id,
    required this.title,
    required this.deadline,
    this.isCompleted = false,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'deadline': deadline,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
  };

  factory ToDoModel.fromMap(Map<String, dynamic> map) => ToDoModel(
    id: map['id'],
    title: map['title'],
    deadline: map['deadline'],
    isCompleted: map['isCompleted'] ?? false,
    createdAt: map['createdAt'] != null
        ? DateTime.parse(map['createdAt'])
        : null,
  );
}
