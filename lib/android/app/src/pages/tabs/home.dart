import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/widgets/global/app_overlay.dart';
import 'package:stream_me/android/app/src/pages/others/help.dart';
import 'package:stream_me/android/app/src/pages/tabs/explore.dart';
import 'package:stream_me/android/app/src/pages/tabs/favourites.dart';
import 'package:stream_me/android/app/src/pages/tabs/watchlist.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';

import '../../auth/auth_main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Body of the home page of the app.
/// The stack widget connects a container with a Logout button inside and a container with icon buttons
class _HomePageState extends State<HomePage> {
  late List streams = allStreams; //temporarily
  ColorPalette color = ColorPalette();
  Images image = Images();

  @override
  Widget build(BuildContext context) {
    streams.sort((a, b) => a.title
        .toString()
        .toLowerCase()
        .compareTo(b.title.toString().toLowerCase())); //temporarily

    return Container(
      color: color.middleBackgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 45.0),
            child: Image.asset(image.streameIconWhite, width: 165),
          ),
          Expanded(
            child: Container(
              color: color.middleBackgroundColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            addHomeCards(
                                const FavouritesPage(),
                                Icons.favorite,
                                "Favourites",
                                2, //6
                                image.favourites),
                            const SizedBox(
                              height: 17,
                            ),
                            addHomeCards(
                                const ExplorePage(),
                                Icons.travel_explore_outlined,
                                "Explore",
                                3, //5
                                image.explore),
                          ]),
                          Column(
                            children: [
                              addHomeCards(
                                  const WatchlistPage(),
                                  Icons.format_list_bulleted_rounded,
                                  "Watchlist",
                                  4, //8
                                  image.watchlist),
                              const SizedBox(height: 17),
                              addHomeCards(
                                  const HelpPage(),
                                  Icons.help_outline,
                                  "Help",
                                  5, //9
                                  image.help),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            color: color.backgroundColor,
                            width: 130,
                            height: 45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 12.0),
                                const Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut().then(
                                        (value) => Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AuthPage()),
                                                (route) => false));
                                  },
                                  icon: const Icon(Icons.logout_outlined),
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Function that adds buttons on home page for navigation
  GestureDetector addHomeCards(StatefulWidget routeWidget, IconData icon,
      String title, int index, String image) {
    return GestureDetector(
      onTap: () {
        if (index != 5) {
          //prevent to navigate to non existing 6th (index = 5) navigation bar item Help
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) {
                    return AppOverlay(
                        fromHomeButton: true,
                        currentPageIndex: index);
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                  transitionsBuilder:
                      (context, animation1, animation2, child) =>
                          FadeTransition(opacity: animation1, child: child)));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpPage()),
          );
        }
      },
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: color.backgroundColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: 1,
                    blurRadius: 4),
              ]),
          height: 190, //200, 180
          width: 170,
          //color: widget.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    //BorderRadius.only(topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
                    child: InkWell(
                      onTap: () {},
                      child: Image.asset(
                        image,
                        height: 135, //150
                        width: 135,
                        fit: BoxFit.cover,
                      ),
                    )),
                addHomeCardText(title, icon)
              ]),
            ),
          ),
        ),
      ),
    );
    /* MaterialButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AppOverlay(
                        title: title,
                        body: routeWidget,
                        selectedMenuIndex: index,
                      )));
        },
        color: Colors.white,
        textColor: widget.backgroundColor,
        padding: const EdgeInsets.all(10.0),
        shape: const CircleBorder(),
        child: Icon(
          icon,
          size: 45,
        ),
      ),*/
  }

  /// Function that adds button's text on home page
  Padding addHomeCardText(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17.0, 8.0, 17.0, 0.0),
      //child: ClipRRect(
      //  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15.0), bottomRight: Radius.circular(15.0)),
      /*child: Container(
          color: Colors.grey.shade300,
          height: 25,*/
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          icon,
          color: Colors.grey.shade300,
          size: 20,
        ),
        const SizedBox(width: 4),
        Text(title, style: TextStyle(color: Colors.grey.shade300, fontSize: 16))
      ]),
      //),
      //),
    );
  }
}
