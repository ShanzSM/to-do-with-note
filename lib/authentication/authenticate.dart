import 'package:flutter/material.dart';
import 'package:todo_app/authentication/register.dart';

import 'login.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool login = true;
  //toggle page
  void switchpages() {
    setState(() {
      login = !login;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (login == true) {
      return Login(toggle: switchpages);
    } else {
      return Register(toggle: switchpages);
    }
  }
}
