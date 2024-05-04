import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Login_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      /*  initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
      }, */
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
