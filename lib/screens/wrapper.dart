import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/user_model.dart';
import 'package:todo_app/screens/home_page.dart';
import 'package:todo_app/authentication/authenticate.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    //the user data that the provider provide this can be user data or can be null.
    final user = Provider.of<UserModel?>(context);
    if (user == null || user.uid == "*") {
      return const Authenticate();
    } else {
      return const HomePage();
    }
  }
}
