import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'home_page.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);
  final Color middleBackgroundColor = const Color.fromRGBO(
      44, 40, 40, 1.0);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    return MovieAppBar(title: "Help", body: buildBody(),);
  }

  Widget buildBody() {
    return Container(
      color: widget.middleBackgroundColor,
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
            backgroundColor: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
          ),
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())),
          child: const Text("Go Back"),
        ),
      ),
    );
  }
}
