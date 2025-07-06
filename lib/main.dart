import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/model/note_model.dart';
import 'package:todo_app/model/todo.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/service/auth.dart';
import 'package:todo_app/model/user_model.dart';
import 'package:todo_app/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/app/router.dart';

Future<void> main() async {
  //  Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  //  Initialize Firebase
  await Firebase.initializeApp();

  //  Initialize Hive with Flutter support
  await Hive.initFlutter();

  //  Register adapters
  Hive.registerAdapter(NoteModelAdapter());
  Hive.registerAdapter(TodoAdapter());

  //  Open boxes
  await Hive.openBox('notes');
  await Hive.openBox('todos');

  runApp(
    StreamProvider<UserModel?>.value(
      initialData: UserModel(uid: "*"),
      value: AuthServices().user,
      child: const MyApp(),
    ),
  );
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
        fontFamily: 'Roboto',
      ),
      routerConfig: AppRouter.router,
    );
  }
}
