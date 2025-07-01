import 'package:flutter/material.dart';
import 'package:todo_app/app/router.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/widgets/category_card.dart';
import '../widgets/todo_card.dart';
import 'package:todo_app/ui/to_do_page.dart';
import 'package:todo_app/service/todo_service.dart';
import 'package:todo_app/service/note_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int notesCount = 0;
  int tasksCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  void _loadCounts() async {
    final notes = await NoteService().loadNotes();
    final tasks = ToDoService().tasks;
    setState(() {
      notesCount = notes.length;
      tasksCount = tasks.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final pendingTasks = ToDoService().tasks
        .where((t) => !t.isCompleted)
        .toList();
    final completedTasksCount = ToDoService().tasks
        .where((t) => t.isCompleted)
        .length;
    final totalTasks = pendingTasks.length + completedTasksCount;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Top Greeting Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Hello Tishan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.orangeAccent,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // Progress Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Today's Progress",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "You have completed $completedTasksCount of the $totalTasks tasks!",
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              value: totalTasks == 0
                                  ? 0
                                  : completedTasksCount / totalTasks,
                              strokeWidth: 8,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.cyan,
                              ),
                            ),
                          ),
                          Text(
                            "${(totalTasks == 0 ? 0 : (completedTasksCount / totalTasks * 100)).toStringAsFixed(0)}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // Notes and Todo List Cards
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await AppRouter.router.push("/notes");
                        _loadCounts();
                      },
                      child: CategoryCard(
                        title: "Notes",
                        count: notesCount,
                        icon: Icons.sticky_note_2_outlined,
                        countLabel: 'notes',
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await AppRouter.router.push("/todos");
                        _loadCounts();
                      },
                      child: CategoryCard(
                        title: "To-Do List",
                        count: tasksCount,
                        icon: Icons.checklist,
                        countLabel: 'tasks',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                // Pending Tasks Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Pending Tasks",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ToDoPage(initialTabIndex: 2),
                            ),
                          );
                          setState(() {}); // Refresh after returning
                        },
                        child: const Text(
                          "See All",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Pending Tasks List
                Column(
                  children: [
                    for (final task in pendingTasks.take(3)) ...[
                      ToDoCard(
                        task: task,
                        onToggleComplete: () {
                          ToDoService().toggleComplete(task);
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
