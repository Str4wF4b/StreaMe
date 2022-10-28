import 'package:flutter/material.dart';

import 'app_bar.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        style: TextButton.styleFrom(
          textStyle: TextStyle(
            color: Colors.green,
            fontSize: 30,
          ),
        ),
        onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MovieAppBar(title: "StreaMe",))),
        child: Text("Go Back"),
      ),
    );
  }
}
