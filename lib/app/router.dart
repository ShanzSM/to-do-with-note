import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/screens/notes_by_category.dart';
import 'package:todo_app/screens/notes_page.dart';
import 'package:todo_app/screens/to_do_page.dart';
import 'package:todo_app/screens/add_todo_page.dart';
import 'package:todo_app/screens/loading_screen.dart';
import 'package:todo_app/screens/wrapper.dart';
import 'package:todo_app/screens/edit_todo_page.dart';
import 'package:todo_app/screens/profile_page.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    debugLogDiagnostics: true,
    initialLocation: '/wrapper',
    routes: [
      // Loading Screen route
      GoRoute(
        name: "loading",
        path: '/loading',
        builder: (context, state) {
          return LoadingScreen();
        },
      ),
      // Wrapper route
      GoRoute(
        name: "wrapper",
        path: '/wrapper',
        builder: (context, state) {
          return const Wrapper();
        },
      ),
      // Home Page route
      GoRoute(
        name: "home",
        path: '/home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOut;
            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
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
      GoRoute(
        name: "add-todo",
        path: '/add-todo',
        builder: (context, state) {
          return const AddToDoPage();
        },
      ),
      GoRoute(
        name: "edit-todo",
        path: '/edit-todo',
        builder: (context, state) {
          final EditToDoPage editPage = state.extra as EditToDoPage;
          return editPage;
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
      GoRoute(
        name: "profile",
        path: '/profile',
        builder: (context, state) {
          return const ProfilePage();
        },
      ),
    ],
  );
}
