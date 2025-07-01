import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_model.dart';
import '../widgets/todo_card.dart';
import 'add_todo_page.dart';
import 'package:todo_app/service/todo_service.dart';

class ToDoPage extends StatefulWidget {
  final int initialTabIndex;
  const ToDoPage({super.key, this.initialTabIndex = 0});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  void _addTask(ToDoModel task) {
    setState(() {
      ToDoService().addTask(task);
    });
  }

  void _removeTask(ToDoModel task) {
    setState(() {
      ToDoService().removeTask(task);
    });
  }

  void _toggleComplete(ToDoModel task) {
    setState(() {
      final wasCompleted = task.isCompleted;
      ToDoService().toggleComplete(task);
      // Enforce max 4 completed tasks
      final completed = ToDoService().tasks
          .where((t) => t.isCompleted)
          .toList();
      if (!wasCompleted && task.isCompleted && completed.length > 4) {
        // Remove the oldest completed task
        final oldest = ToDoService().tasks.indexWhere((t) => t.isCompleted);
        if (oldest != -1) {
          ToDoService().removeTask(ToDoService().tasks[oldest]);
        }
      }
    });
  }

  List<ToDoModel> get _todayTasks => ToDoService().tasks
      .where((t) => t.deadline == 'Today' && !t.isCompleted)
      .toList();
  List<ToDoModel> get _pendingTasks => ToDoService().tasks
      .where((t) => t.deadline != 'Today' && !t.isCompleted)
      .toList();
  List<ToDoModel> get _completedTasks {
    final completed = ToDoService().tasks.where((t) => t.isCompleted).toList();
    return completed.length > 4
        ? completed.sublist(completed.length - 4)
        : completed;
  }

  List<ToDoModel> get _activeTasks =>
      ToDoService().tasks.where((t) => !t.isCompleted).toList();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.initialTabIndex,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.white),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Text(
                'To-do-list',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 34,
                ),
              ),
            ),
            const TabBar(
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.blueAccent,
              tabs: [
                Tab(text: "Today's"),
                Tab(text: "Pending"),
                Tab(text: "All Tasks"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _taskListSection(_todayTasks),
                  _taskListSection(_pendingTasks),
                  _taskListSection(_activeTasks),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            side: BorderSide(color: Colors.white, width: 2),
          ),
          onPressed: () async {
            final newTask = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddToDoPage()),
            );
            if (newTask != null && newTask is ToDoModel) {
              _addTask(newTask);
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _taskListSection(List<ToDoModel> tasks) {
    final completedTasks = _completedTasks;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < tasks.length; i++) ...[
              Dismissible(
                key: Key(tasks[i].title + tasks[i].deadline),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  _removeTask(tasks[i]);
                },
                child: ToDoCard(
                  task: tasks[i],
                  onToggleComplete: () => _toggleComplete(tasks[i]),
                ),
              ),
              if (i != tasks.length - 1) const SizedBox(height: 20),
            ],
            if (completedTasks.isNotEmpty) ...[
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Completed Tasks",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
              for (int i = 0; i < completedTasks.length; i++) ...[
                Opacity(
                  opacity: 0.4,
                  child: ToDoCard(
                    task: completedTasks[i],
                    onToggleComplete: () => _toggleComplete(completedTasks[i]),
                  ),
                ),
                if (i != completedTasks.length - 1) const SizedBox(height: 20),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
