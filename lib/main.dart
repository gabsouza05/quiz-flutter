import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const RaulSeixasQuizApp());
}

class RaulSeixasQuizApp extends StatelessWidget {
  const RaulSeixasQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Raul Seixas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}