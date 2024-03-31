import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/widgets/global/app_overlay.dart';
import 'package:stream_me/android/app/src/pages/others/help.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';

import '../../auth/auth_main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ColorPalette _color = ColorPalette();
  final Images _image = Images();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color.backgroundColor,
      body: Container(
        color: _color.middleBackgroundColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 65.0),
              child: Image.asset(_image.streameIconWhite, width: 165),
            ),
            Expanded(
              child: Container(
                color: _color.middleBackgroundColor,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // First Column with 2 clickable home buttons Favourites and Explore:
                            Column(children: [
                              addHomeButtons(Icons.favorite, "Favourites", 2,
                                  _image.favourites),
                              const SizedBox(
                                height: 45,
                              ),
                              addHomeButtons(Icons.travel_explore_outlined,
                                  "Explore", 3, _image.explore),
                            ]),
                            // Second Column with 2 clickable home buttons Watchlist and Help:
                            Column(
                              children: [
                                addHomeButtons(
                                    Icons.format_list_bulleted_rounded,
                                    "Watchlist",
                                    4,
                                    _image.watchlist),
                                const SizedBox(height: 45),
                                addHomeButtons(
                                    Icons.help_outline, "Help", 5, _image.help),
                              ],
                            ),
                          ],
                        ),
                        // The Logout button at the bottom of the screen:
                        Padding(
                          padding: const EdgeInsets.only(top: 55.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              color: _color.backgroundColor,
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
                                      await FirebaseAuth.instance
                                          .signOut()
                                          .then((value) => Navigator.of(context)
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
      ),
    );
  }

  /// A function that adds the home buttons to the Home Page with integrated navigation
  /// icon: The icon of a home button followed by the title
  /// title: The title of a home button
  /// index: The index of the tab to navigates to
  /// image: The image of the home button
  GestureDetector addHomeButtons(
      IconData icon, String title, int index, String image) {
    return GestureDetector(
      onTap: () {
        if (index != 5) {
          setState(() {});
          // prevent to navigate to non existing 6th (index = 5) bottom navigation bar item "Help"
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) {
                    return AppOverlay(
                        fromHomeButton: true, currentPageIndex: index);
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
        // The home button with rounded images:
        // Border around the home button:
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: _color.backgroundColor,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: 1,
                    blurRadius: 4),
              ]),
          height: 150,
          width: 150,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  // Home button picture:
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: InkWell(
                        onTap: () {},
                        child: Image.asset(
                          image,
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      )),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 102.0, bottom: 10.0),
                      child: Container(
                        // Faded effect of the text background:
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                              Colors.transparent, // or black
                              Colors.black45, // or black54
                              Colors.black45,
                              Colors.transparent
                            ],
                                stops: [
                              0.0,
                              0.2,
                              0.8,
                              1.0
                            ])),
                      ),
                    ),
                  ),
                  // Text of the home button:
                  Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: addHomeCardText(title, icon)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// A function that adds a text to its corresponding home button on the Home Page
  /// title: The title of a home button
  /// icon: The icon of a home button followed by the title
  Padding addHomeCardText(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 6.0, 17.0, 0.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          icon,
          color: _color.bodyTextColor,
          size: 17,
        ),
        const SizedBox(width: 4),
        Text(title, style: TextStyle(color: _color.bodyTextColor, fontSize: 13))
      ]),
    );
  }
}
