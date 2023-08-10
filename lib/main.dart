import 'package:flutter/material.dart';

void main() {
  runApp(const StreetWorkoutApp());
}

class StreetWorkoutApp extends StatelessWidget {
  const StreetWorkoutApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Street Workout',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        //useMaterial3: true,
        primaryColor: const Color(0xFFE9435A),
      ),
      home: Container(),
    );
  }
}
