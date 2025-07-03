import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class LoadingScreen extends StatefulWidget {
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    // Delay 3 seconds, then navigate using go_router
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(Duration(seconds: 3), () {
        if (mounted) {
          context.go('/wrapper'); //  Use GoRouter navigation
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/animation.json', // Ensure correct path in pubspec.yaml
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
