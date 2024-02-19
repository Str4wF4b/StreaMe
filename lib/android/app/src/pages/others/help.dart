import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  ColorPalette color = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context)),
          title: Text("Help",
              style: TextStyle(
                  color: color.bodyTextColor, fontWeight: FontWeight.w500)),
          centerTitle: true,
          backgroundColor: color.backgroundColor,
          elevation: 0.0,
        ),
        body: Container(
          color: color.backgroundColor,
          child: Center(
              child: Text("I need help, fr",
                  style: TextStyle(
                      color: Colors.grey.shade300,
                      fontWeight: FontWeight.bold,
                      fontSize: 30))),
        ));
  }
}
