import 'package:flutter/material.dart';
import 'app_overlay.dart';
import 'home_page.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);
  final Color middleBackgroundColor = const Color.fromRGBO(44, 40, 40, 1.0);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Help"),
          centerTitle: true,
          backgroundColor: widget.backgroundColor,
          elevation: 0.0,
        ),
        body: Container(
          color: widget.backgroundColor,
          child: Center(
              child: Text("I need help, fr",
                  style: TextStyle(
                      color: Colors.grey.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 30))),
        ));
  }
}
