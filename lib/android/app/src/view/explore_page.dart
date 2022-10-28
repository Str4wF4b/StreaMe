import 'package:flutter/material.dart';

import 'app_bar.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
