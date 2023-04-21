import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'android/app/src/view/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // starting with Firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
