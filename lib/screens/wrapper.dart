import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/user_model.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/authentication/authenticate.dart';
import 'package:go_router/go_router.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //the user data that the provider provide this can be user data or can be null.
    final user = Provider.of<UserModel?>(context);
    if (user == null || user.uid == "*") {
      return const Authenticate();
    } else {
      // Navigate to home page using GoRouter
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/home');
      });
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
  }
}
