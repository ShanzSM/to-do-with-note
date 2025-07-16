import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  final String title;
  final DateTime time;
  final DateTime date;
  final bool isDone;

  Todo({
    String? id,
    required this.title,
    required this.time,
    required this.date,
    required this.isDone,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'time': time.toIso8601String(),
    'date': date.toIso8601String(),
    'isDone': isDone,
  };

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
    id: map['id'],
    title: map['title'],
    time: DateTime.parse(map['time']),
    date: DateTime.parse(map['date']),
    isDone: map['isDone'] ?? false,
  );
}
