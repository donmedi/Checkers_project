import 'package:checkers_game/checkers/screens/checkersPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Checkers',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const CheckersHome());
  }
}
