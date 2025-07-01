import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/ui/home_page.dart';
import 'package:todo_app/ui/notes_by_category.dart';
import 'package:todo_app/ui/notes_page.dart';
import 'package:todo_app/ui/to_do_page.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: [
      //Home Page route
      GoRoute(
        name: "home",
        path: '/',
        builder: (context, state) {
          return HomePage();
        },
      ),
      GoRoute(
        name: "notes",
        path: '/notes',
        builder: (context, state) {
          return const NotesPage();
        },
      ),
      GoRoute(
        name: "todos",
        path: '/todos',
        builder: (context, state) {
          return const ToDoPage();
        },
      ),
      //Notes By Category Page
      GoRoute(
        name: 'category',
        path: '/category',
        builder: (context, state) {
          final String category = state.extra as String;
          return NotesByCategory(category: category);
        },
      ),
    ],
  );
}
