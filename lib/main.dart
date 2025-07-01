import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/app/router.dart';
import 'package:todo_app/model/note_model.dart';
import 'package:todo_app/model/todo.dart';

Future<void> main() async {
  //  Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  //  Initialize Hive with Flutter support
  await Hive.initFlutter();

  //  Register adapters
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(TodoAdapter());

  //  Open boxes
  await Hive.openBox('notes');
  await Hive.openBox('todos');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'To-Do App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Roboto', // Optional
      ),
      routerConfig: AppRouter.router,
    );
  }
}
