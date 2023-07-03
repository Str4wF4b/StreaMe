import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/components/app_bar.dart';
import 'package:stream_me/android/app/src/components/bottom_app_bar.dart';
import 'package:stream_me/android/app/src/components/list_items.dart';
import 'package:stream_me/android/app/src/view/explore_page.dart';
import 'package:stream_me/android/app/src/view/favourites_page.dart';
import 'package:stream_me/android/app/src/view/help.dart';
import 'package:stream_me/android/app/src/view/search_page.dart';
import 'package:stream_me/android/app/src/view/watchlist.dart';

import '../components/edit_profile_page.dart';
import '../components/navigation_icons.dart';
import '../services/auth_page.dart';
import 'filter_page.dart';
import 'home_page.dart';

class AppOverlayOld extends StatefulWidget {
  AppOverlayOld(
      {Key? key, required this.title, required this.body, required this.selectedMenuIndex})
      : super(key: key);

  final String title;
  int selectedIndex = 0;
  int selectedMenuIndex;
  final Widget body;
  //final int index;

  //statt body, ganze Liste mti seiten machen und statt body in Konstrukter einfach die positition in der liste nehmen
  //statt Body, alle möglichen Seiten in eine List rein, den body aus allen seiten als hauptrückgabe, kein scaffold zurückgeben, Titel der Seiten wie Bodys und bei beiden Listen über index bei den Body hier zugreifen
  //late StreameBottomAppBar streameBottomAppBar = StreameBottomAppBar();
  final pages = [
    Container(), //Index = 0, selectedIndex = 0
    SearchPage(), //Index = 1, selectedIndex = 1
    FavouritesPage(), //Index = 2, selectedIndex = 2
    FilterPage(), //Index = 3, selectedIndex = 3
    HomePage(), //Index = 4, selectedMenuIndex = 4
    ExplorePage(), //Index = 5, selectedMenuIndex = 5
    FavouritesPage(), //Index = 6, selectedMenuIndex = 6
    FavouritesPage(), //Index = 7, selectedMenuIndex = 6
    WatchlistPage(), //Index = 8, selectedMenuIndex = 8
    HelpPage(), //Index = 9, selectedMenuIndex = 9
  ];
  final titles = [
    "",
    "Search",
    "Favourites",
    "Filter",
    "Home",
    "Explore",
    "Favourites",
    "Favourites",
    "Watchlist",
    "Help"
  ];

  //int selectedIndex = this.selectedIndex;

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);

  @override
  State<AppOverlayOld> createState() => _AppOverlayState();
}

/**
 * The part of the AppBar that is the same for every page
 * includes: AppBar overlay, profile changes, menu navigation
 */
//TODO: make appBar transparent when scrolling
class _AppOverlayState extends State<AppOverlayOld> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: StreameAppBar(title: checkTitle()),
        //app bar on top of every page
        endDrawer: Drawer(
          backgroundColor: widget.backgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0)
              )
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                buildHeader(context),
                buildMenuItems(context),
              ],
            ),
          ),
        ),
        body: checkInput(),
        bottomNavigationBar: BottomAppBar(
          elevation: 0.0,
          color: Colors.transparent,
          child: Container(
            height: 52.0,
            width: MediaQuery.of(context).size.width,
            color: widget.backgroundColor,
            child: Padding(
              padding:
              const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 3.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  NavigationIcons(
                      iconText: "Search",
                      icon: Icons.search_outlined,
                      selected: widget.selectedIndex == 1,
                      onPressed: () {
                        widget.selectedIndex = 1;
                        setState(() {
                          widget.selectedIndex = 1;
                        });
                      }),
                  NavigationIcons(
                      iconText: "Favourites",
                      icon: Icons.favorite,
                      selected: widget.selectedIndex == 2,
                      onPressed: () {
                        setState(() {
                          widget.selectedIndex = 2;
                        });
                      }),
                  NavigationIcons(
                      iconText: "Filter",
                      icon: Icons.filter_list,
                      selected: widget.selectedIndex == 3,
                      onPressed: () {
                        setState(() {
                          widget.selectedIndex = 3;
                        });
                      }),
                  NavigationIcons(
                      iconText: "Home",
                      icon: Icons.home,
                      selected: widget.selectedIndex == 4,
                      onPressed: () {
                        widget.selectedIndex = 4;
                        setState(() {
                          widget.selectedIndex = 4;
                        });
                      }),
                ],
              ),
            ),
          ),
        )

      //StreameBottomAppBar(selectedIndex: widget.selectedIndex)

      /*BottomAppBar( //app bar on bottom of every page
        color: widget.backgroundColor,
        child: Container(
          //color: Color.fromRGBO(180, 180, 180, 1.0),
          height: 52.0,
          color: widget.backgroundColor,
          */ /*decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
            color: Color.fromRGBO(200, 200, 200, 1.0),
          ),*/ /*
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //the icons of the BottomAppBar
              addBottomIcons(Icons.search_outlined, "Search",
                  const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0), SearchPage()),
              addBottomIcons(
                  Icons.favorite, "Saved", EdgeInsets.zero, FavouritesPage()),
              addBottomIcons(Icons.filter_list_outlined, "Filter",
                  const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0), FilterPage()),
            ],
          ),
        ),
      ),*/
    );
  }

  Widget checkInput() {
    if (widget.selectedIndex == 0) {
      return widget.pages[widget.selectedMenuIndex];
    } else {
      return widget.pages[widget.selectedIndex];
    }
  }

  String checkTitle() {
    if (widget.selectedIndex == 0) {
      return widget.titles[widget.selectedMenuIndex];
    } else {
      return widget.titles[widget.selectedIndex];
    }
  }

  /*if (index == 0) {
      print(index);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchPage()));
    }
    if (index == 1) {
      print(index);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FavouritesPage()));
    }
    if (index == 2) {
      print(index);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => FilterPage()));
    }
    print(" ---------------------------------- $index");
  }*/

  /**
   * Function that builds the icons of the BottomAppBar
   */
  //TODO: make icons selected if selected and unselected if not
  Padding addBottomIcons(
      IconData icon, String iconLabel, EdgeInsets insets, StatefulWidget page) {
    return Padding(
      padding: insets,
      child: SizedBox.fromSize(
        size: const Size(66, 66),
        child: ClipOval(
          child: Material(
            //color: const Color.fromRGBO(200, 200, 200, 1.0),
            color: widget.backgroundColor,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => page));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(icon, color: Colors.white), // <-- Icon
                  Text(iconLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      )), // <-- Text
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /**
   * Function that builds the header space of the navigation drawer
   */
  Widget buildHeader(BuildContext context) => Container(
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
    ),
  );

  /**
   * Function that builds the elements of the navigation drawer
   */
  Widget buildMenuItems(BuildContext context) => Container(
    padding: const EdgeInsetsDirectional.fromSTEB(6.0, 8.0, 6.0, 0.0),
    child: Wrap(children: [
      ListItems(
        icon: Icons.home,
        label: "Home",
        selectedIndex: 4,
        onTap: () {
          setState(() {
            widget.selectedIndex = 0;
            widget.selectedMenuIndex = 4;
            Navigator.of(context).pop();
          });
        },
      ),
      //buildListItems(Icons.home, "Home", const HomePage()),
      const Divider(color: Colors.white),
      //buildListItems(Icons.travel_explore_rounded, "Explore", const ExplorePage()),
      ListItems(
        icon: Icons.explore,
        label: "Explore",
        selectedIndex: 5,
        onTap: () {
          setState(() {
            widget.selectedIndex = 0;
            widget.selectedMenuIndex = 5;
            Navigator.of(context).pop();
          });
        },
      ),
      const Divider(color: Colors.white),
      ListItems(
        icon: Icons.local_movies_outlined,
        label: "My Movies",
        selectedIndex: 6,
        onTap: () {
          setState(() {
            widget.selectedIndex = 2;
            widget.selectedMenuIndex = 6;
            Navigator.of(context).pop();
          });
          print(widget.selectedMenuIndex);
        },
      ),
      //buildListItems(Icons.local_movies_outlined, "My Movies", const FavouritesPage()),
      const Divider(color: Colors.white),
      ListItems(
        icon: Icons.movie_outlined,
        label: "My Series",
        selectedIndex: 7,
        onTap: () {
          setState(() {
            widget.selectedIndex = 2;
            widget.selectedMenuIndex = 7;
            Navigator.of(context).pop();
          });
        },
      ),
      const Divider(color: Colors.white),
      ListItems(
        icon: Icons.format_list_bulleted_rounded,
        label: "Watchlist",
        selectedIndex: 8,
        onTap: () {
          setState(() {
            widget.selectedIndex = 0;
            widget.selectedMenuIndex = 8;
            Navigator.of(context).pop();
          });
        },
      ),
      //buildListItems(Icons.movie_outlined, "My Series", const FavouritesPage()),
      const Divider(color: Colors.white),
      ListItems(
        icon: Icons.help_outline,
        label: "Help",
        selectedIndex: 9,
        onTap: () {
          setState(() {
            widget.selectedIndex = 0;
            widget.selectedMenuIndex = 9;
            Navigator.of(context).pop();
          });
        },
      ),
      //buildListItems(Icons.help_outline, "Help", const HelpPage()),
      const Divider(color: Colors.white),
      ListItems(
          icon: Icons.logout,
          label: "Logout",
          selectedIndex: 10,
          onTap: () async {
            widget.selectedIndex = 0;
            return await FirebaseAuth.instance.signOut().then((value) =>
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const AuthPage()),
                        (route) => false));
          }),
      //buildLogoutItem(Icons.logout_outlined, "Logout"),
    ]),
  );

  /**
   * Function that determines the style of an element of the navigation drawer
   */
  ListTile buildListItems(
      IconData icon, String label, StatefulWidget stflWidget) {
    return ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        onTap: () {
          widget.selectedIndex = 4;
          /*Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => stflWidget))*/
          print("${widget.selectedIndex}");
        });
  }

  /**
   * Function that causes a user logout inside the navigation drawer
   */
  ListTile buildLogoutItem(IconData icon, String label) {
    return ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        onTap: () async => await FirebaseAuth.instance.signOut().then((value) =>
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthPage()),
                    (route) => false)));
  }
}
