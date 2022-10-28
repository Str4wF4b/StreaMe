import 'package:flutter/material.dart';

import 'app_bar.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
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

