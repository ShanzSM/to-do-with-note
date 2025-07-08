import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_model.dart';

// Define the ToDoCard widget here. Example implementation:
class ToDoCard extends StatelessWidget {
  final ToDoModel task;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onTap;

  const ToDoCard({
    super.key,
    required this.task,
    this.onToggleComplete,
    this.onTap,
  });

  Color _getPriorityColor() {
    switch (task.deadline.toLowerCase()) {
      case 'today':
        return Colors.red;
      case 'tomorrow':
        return Colors.orange;
      case 'day after tomorrow':
        return Colors.green;
      case 'this week':
        return Colors.yellow;
      case 'next week':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getPriorityColor(),
              shape: BoxShape.circle,
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              color: Colors.white,
              decoration: task.isCompleted == true
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: Text(
            task.deadline,
            style: const TextStyle(color: Colors.white54),
          ),
          trailing: GestureDetector(
            onTap: onToggleComplete,
            child: Icon(
              task.isCompleted == true
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: task.isCompleted == true ? Colors.green : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}
