import 'package:flutter/material.dart';
import 'package:quiz/screen/questionSelection.dart';
import 'package:quiz/screen/quizPage.dart';
import 'package:quiz/screen/rankPage.dart';
import 'package:quiz/screen/scorePage.dart';
import 'package:quiz/screen/splash.dart';

import 'screen/categorySelection.dart';
import 'screen/languageSelection.dart';
import 'screen/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Gilroy',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}





