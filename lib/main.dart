import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/firebase_options.dart';
import 'android/app/src/view/auth_page.dart';
import 'android/app/src/view/login_page.dart';
import 'android/app/src/view/login_page_alpha.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // starting with Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthPage(),
    );
  }
}
