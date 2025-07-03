import 'package:flutter/material.dart';
import 'package:todo_app/app/router.dart';
import 'package:todo_app/model/todo_model.dart';
import 'package:todo_app/widgets/category_card.dart';
import '../widgets/todo_card.dart';
import 'package:todo_app/screens/to_do_page.dart';
import 'package:todo_app/service/todo_service.dart';
import 'package:todo_app/service/note_service.dart';
import 'package:todo_app/service/auth.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int notesCount = 0;
  int tasksCount = 0;
  int categoriesCount = 0;
  int _currentCard = 0;
  late PageController _pageController;
  Timer? _carouselTimer;
  final GlobalKey<AnimatedListState> _pendingListKey =
      GlobalKey<AnimatedListState>();
  List<ToDoModel> _pendingTasks = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadCounts();
    _startAutoSlide();
    _initPendingTasks();
  }

  void _initPendingTasks() {
    setState(() {
      _pendingTasks = ToDoService().tasks.where((t) => !t.isCompleted).toList();
    });
  }

  void _startAutoSlide() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentCard + 1) % 3;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _loadCounts() async {
    final notes = await NoteService().loadNotes();
    final tasks = ToDoService().tasks;
    final categories = notes.map((n) => n.category).toSet();
    setState(() {
      notesCount = notes.length;
      tasksCount = tasks.length;
      categoriesCount = categories.length;
      _pendingTasks = tasks.where((t) => !t.isCompleted).toList();
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
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
    final user = Provider.of<UserModel?>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 36,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.elliptical(1500, 300),
                    bottomRight: Radius.elliptical(1500, 300),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hello Tishan",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Welcome back!",
                          style: TextStyle(color: Colors.black54, fontSize: 15),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.black,
                            size: 24,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          tooltip: 'Sign Out',
                          onPressed: () async {
                            await AuthServices().signOut();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Progress Card Carousel (auto-slide, stops on user interaction)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 140,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentCard = index;
                            });
                            // Stop auto-slide if user slides manually
                            _carouselTimer?.cancel();
                          },
                          children: [
                            // Progress Card
                            _GradientCard(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
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
                                              : completedTasksCount /
                                                    totalTasks,
                                          strokeWidth: 8,
                                          backgroundColor: Colors.white24,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(Colors.redAccent),
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
                            // Categories Card
                            _GradientCard(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.category,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$categoriesCount Categories',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Total Notes Card
                            _GradientCard(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.sticky_note_2,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '$notesCount Notes',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentCard == index
                                  ? Colors.cyan
                                  : Colors.white24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // End Progress Card Carousel
              const SizedBox(height: 20),

              // Notes and Todo List Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
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
              ),

              const SizedBox(height: 20),

              // Pending Tasks Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedList(
                  key: _pendingListKey,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  initialItemCount: _pendingTasks.length,
                  itemBuilder: (context, index, animation) {
                    final task = _pendingTasks[index];
                    return SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: 0.0,
                      child: Column(
                        children: [
                          ToDoCard(
                            task: task,
                            onToggleComplete: () {
                              _removePendingTask(index);
                              ToDoService().toggleComplete(task);
                              _initPendingTasks();
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Completed Tasks Header and List
              if (completedTasksCount > 0) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Completed Tasks",
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (final task in ToDoService().tasks.where(
                        (t) => t.isCompleted,
                      )) ...[
                        Dismissible(
                          key: ValueKey(task.title + task.deadline),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.redAccent,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              ToDoService().removeTask(task);
                            });
                          },
                          child: ToDoCard(
                            task: task,
                            onToggleComplete: () {
                              ToDoService().toggleComplete(task);
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ],
                  ),
                ),
              ],
              if (user != null && !isGoogleUser())
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OutlinedButton.icon(
                    icon: Image.asset(
                      'assets/google.png',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text('Sign in with Google'),
                    onPressed: () async {
                      final result = await AuthServices().signInWithGoogle();
                      if (result != null) {
                        // Optionally, show a success message or reload the page
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Google sign-in failed.'),
                          ),
                        );
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _removePendingTask(int index) {
    final removedTask = _pendingTasks.removeAt(index);
    _pendingListKey.currentState?.removeItem(
      index,
      (context, animation) => SizeTransition(
        sizeFactor: animation,
        axisAlignment: 0.0,
        child: Column(
          children: [
            ToDoCard(task: removedTask, onToggleComplete: () {}),
            const SizedBox(height: 20),
          ],
        ),
      ),
      duration: const Duration(milliseconds: 500),
    );
  }

  bool isGoogleUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    for (final info in user.providerData) {
      if (info.providerId == 'google.com') return true;
    }
    return false;
  }
}

// Gradient card widget for carousel
class _GradientCard extends StatelessWidget {
  final Widget child;
  const _GradientCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFff9966), Color(0xFFff5e62), Color(0xFF36d1c4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
