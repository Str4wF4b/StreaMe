import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:stream_me/android/app/src/widgets/splash_logo.dart';
import 'package:stream_me/firebase_options.dart';
import 'android/app/src/auth/auth_main.dart';
import 'android/app/src/auth/login.dart';
import 'android/app/src/pages/login_page_alpha.dart';

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
    return GetMaterialApp( //MaterialApp, aber wegen transitions und Get-package "GetMaterialApp"
      home: SplashLogo(),
    );
  }
}
