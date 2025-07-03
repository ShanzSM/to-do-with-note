import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/screens/notes_by_category.dart';
import 'package:todo_app/screens/notes_page.dart';
import 'package:todo_app/screens/to_do_page.dart';
import 'package:todo_app/screens/loading_screen.dart';
import 'package:todo_app/screens/wrapper.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    debugLogDiagnostics: true,
    initialLocation: '/loading',
    routes: [
      // Onboard Screen route
      GoRoute(
        name: "loading",
        path: '/loading',
        builder: (context, state) {
          return LoadingScreen();
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
        name: "wrapper",
        path: '/wrapper',
        builder: (context, state) {
          return const Wrapper();
        },
      ),
    ],
  );
}
