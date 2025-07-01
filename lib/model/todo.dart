import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime time;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final bool isDone;

  Todo({
    String? id,
    required this.title,
    required this.time,
    required this.date,
    required this.isDone,
  }) : id = id ?? const Uuid().v4();
}
