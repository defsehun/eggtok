import 'package:flutter/material.dart';
import 'package:street_workout/constants/sizes.dart';
import 'package:street_workout/features/main_navigation/main_navigation_screen.dart';

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
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE9435A),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // home: const SignUpScreen(),
      home: const MainNavigaionScreen(),
    );
  }
}
