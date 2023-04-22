import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/view/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);
  final Color middleBackgroundColor = const Color.fromRGBO(
      44, 40, 40, 1.0);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MovieAppBar(
      title: "Home",
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      color: widget.middleBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Column(
                children: [
                  //TODO: IconButtons
                  IconButton(
                    icon: const Icon(
                      Icons.travel_explore_rounded,
                      size: 50,
                      color: Colors.white,
                    ), onPressed: () {  },),
                  IconButton(
                    icon: const Icon(
                      Icons.movie_outlined,
                      size: 50,
                      color: Colors.white,
                    ), onPressed: () {  },),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.local_movies_outlined,
                      size: 50,
                      color: Colors.white,
                    ), onPressed: () {  },),
                  IconButton(
                    icon: const Icon(
                      Icons.help_outline,
                      size: 50,
                      color: Colors.white,
                    ), onPressed: () {  },)
                ],
              )
            ],
          )
        ),
    );
  }
}
