import 'package:flutter/material.dart';
import 'app_bar.dart';
import 'home_page.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    return MovieAppBar(title: "Favourites", body: buildBody(),);
  }

  Widget buildBody() {
    return Container(
      color: widget.backgroundColor,
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
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage())),
          child: const Text("Go Back"),
        ),
      ),
    );
  }
}

