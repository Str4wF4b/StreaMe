import 'package:flutter/material.dart';
import 'android/app/src/view/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final Color backgroundColor = Colors.green/*const Color.fromRGBO(38, 35, 35, 1.0)*/;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
