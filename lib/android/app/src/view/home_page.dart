import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/view/app_bar.dart';
import 'package:stream_me/android/app/src/view/explore_page.dart';
import 'package:stream_me/android/app/src/view/favourites_page.dart';
import 'package:stream_me/android/app/src/view/help.dart';
import 'package:stream_me/android/app/src/view/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);
  final Color middleBackgroundColor = const Color.fromRGBO(44, 40, 40, 1.0);

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
    return Stack(children: [
      Container(
        color: widget.middleBackgroundColor,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 60.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  const SizedBox(height: 30),
                  addHomeButton(
                      const ExplorePage(), Icons.travel_explore_outlined),
                  addHomeButtonText("Explore"),
                  const SizedBox(
                    height: 130,
                  ),
                  addHomeButton(const FavouritesPage(), Icons.movie_outlined),
                  addHomeButtonText("My Movies")
                ]),
                Column(
                  children: [
                    const SizedBox(height: 30),
                    addHomeButton(
                        const FavouritesPage(), Icons.local_movies_outlined),
                    addHomeButtonText("My Series"),
                    const SizedBox(height: 130),
                    addHomeButton(const HelpPage(), Icons.help_outline),
                    addHomeButtonText("Help")
                  ],
                ),
              ],
            )),
      ),
      Padding( //Logout button on home page
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 550.0, 0.0, 0.0),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                icon: const Icon(Icons.logout_outlined),
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    ]);
  }

  /**
   * Function that adds buttons on home page for navigation
   */
  MaterialButton addHomeButton(StatefulWidget routeWidget, IconData icon) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => routeWidget),
        );
      },
      color: Colors.white,
      textColor: widget.backgroundColor,
      padding: const EdgeInsets.all(10.0),
      shape: const CircleBorder(),
      child: Icon(
        icon,
        size: 50,
      ),
    );
  }

  /**
   * Function that adds button's text on home page
   */
  Padding addHomeButtonText(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child:
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}
