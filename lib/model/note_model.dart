import 'package:uuid/uuid.dart';

class Note {
  final String id;
  final String title;
  final String category;
  final String content;
  final DateTime date;

  Note({
    String? id,
    required this.title,
    required this.category,
    required this.content,
    required this.date,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'category': category,
    'content': content,
    'date': date.toIso8601String(),
  };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: map['id'],
    title: map['title'],
    category: map['category'],
    content: map['content'],
    date: DateTime.parse(map['date']),
  );
}
