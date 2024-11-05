import 'package:flutter/material.dart';
import 'package:quiz/screen/splash.dart';

import 'global/global.dart';
import 'global/tokenStorage.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Global.token = await TokenStorage.getToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'OpenSans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}





