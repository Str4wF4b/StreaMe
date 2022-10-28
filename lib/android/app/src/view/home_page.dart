import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/view/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MovieAppBar(
      title: "Home Page Dummy",
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      color: widget.backgroundColor,
      child: const Center(
        child: Text(
          "This is your home page",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
