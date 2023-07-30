import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/widgets/global/app_bar.dart';
import 'package:stream_me/android/app/src/widgets/bottom_app_bar.dart';
import 'package:stream_me/android/app/src/widgets/list_items.dart';

import '../../pages/others/edit_profile_page.dart';
import '../navigation_icons.dart';
import '../../auth/auth_main.dart';
import '../../pages/others/filter.dart';
import '../../pages/others/help.dart';
import '../../pages/tabs/home.dart';
import '../../pages/tabs/search.dart';
import '../../pages/tabs/favourites.dart';
import '../../pages/tabs/explore.dart';
import '../../pages/tabs/watchlist.dart';

class AppOverlay extends StatefulWidget {
  AppOverlay(
      {Key? key,
      required this.title,
      required this.body,
      required this.currentPageIndex}) //title, body, selectedMenuIndex dann title, body, selectedIndex
      : super(key: key);

  final String title;
  //int selectedIndex;
  int currentPageIndex;
  //int selectedMenuIndex;
  final Widget body;

  //final int index;

  //statt body, ganze Liste mti seiten machen und statt body in Konstrukter einfach die positition in der liste nehmen
  //statt Body, alle möglichen Seiten in eine List rein, den body aus allen seiten als hauptrückgabe, kein scaffold zurückgeben, Titel der Seiten wie Bodys und bei beiden Listen über index bei den Body hier zugreifen
  //late StreameBottomAppBar streameBottomAppBar = StreameBottomAppBar();
  final pages = [
    HomePage(), //Index = 0, selectedIndex = 0
    SearchPage(), //Index = 1, selectedIndex = 1
    FavouritesPage(), //Index = 2, selectedIndex = 2
    ExplorePage(), //Index = 3, selectedIndex = 3
    WatchlistPage(), //Index = 4, selectedIndex = 4
    HelpPage(), //Index = 5, selectedIndex = 5
  ];
  final titles = [
    "Home",
    "Search",
    "Favourites",
    "Explore",
    "Watchlist",
    "Help"
  ];

  //int selectedIndex = this.selectedIndex;

  @override
  State<AppOverlay> createState() => _AppOverlayState();
}

/**
 * The part of the AppBar that is the same for every page
 * includes: AppBar overlay, profile changes, menu navigation
 */
//TODO: make appBar transparent when scrolling
class _AppOverlayState extends State<AppOverlay> {
  ColorPalette color = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color.backgroundColor,
        appBar: StreameAppBar(
            title: widget.titles[widget
                .currentPageIndex] /*widget.titles[widget.selectedIndex]*/),
        //app bar on top of every page
/*        endDrawer: Drawer(
          backgroundColor: color.backgroundColor,
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
        ),*/
        body: widget.pages[widget.currentPageIndex],
        //widget.pages[widget.selectedIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.grey.shade300,
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade300,
                    height: 1.0);
              } else {
                return const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                    height: 0.9);
              }
            }),
          ),
          child: NavigationBar(
            height: 60.0,
            backgroundColor: color.backgroundColor,
            indicatorColor: Colors.grey.shade300,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(milliseconds: 800),
            destinations: [
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: NavigationDestination(
                    icon: const Icon(Icons.home_outlined, color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.home,
                      color: color.backgroundColor,
                    ),
                    label: "Home"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: NavigationDestination(
                    icon: const Icon(Icons.search_outlined, color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.search,
                      color: color.backgroundColor,
                    ),
                    label: "Search"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: NavigationDestination(
                    icon: const Icon(Icons.favorite_outline, color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.favorite,
                      color: color.backgroundColor,
                    ),
                    label: "Favourites"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: NavigationDestination(
                    icon: const Icon(Icons.travel_explore_outlined,
                        color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.travel_explore,
                      color: color.backgroundColor,
                    ),
                    label: "Explore"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: NavigationDestination(
                    icon: const Icon(Icons.list_rounded, color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.list_rounded,
                      color: color.backgroundColor,
                    ),
                    label: "Watchlist"),
              )
            ],
            selectedIndex: widget.currentPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                widget.currentPageIndex = index;
              });
            },
          ),
        )
        /*BottomAppBar(
          elevation: 0.0,
          color: Colors.transparent,
          child: Container(
            height: 60.0, // 52
            width: MediaQuery.of(context).size.width,
            color: color.backgroundColor,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0), // 40, 40, 3
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  NavigationIcons(
                      iconText: "Home",
                      icon: Icons.home,
                      selected: widget.selectedIndex == 0,
                      onPressed: () {
                        //widget.selectedIndex = 0;
                        setState(() {
                          widget.selectedIndex = 0;
                        });
                      }),
                  NavigationIcons(
                      iconText: "Search",
                      icon: Icons.search_outlined,
                      selected: widget.selectedIndex == 1,
                      onPressed: () {
                        //widget.selectedIndex = 1;
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
                      iconText: "Explore",
                      icon: Icons.travel_explore,
                      selected: widget.selectedIndex == 3,
                      onPressed: () {
                        setState(() {
                          widget.selectedIndex = 3;
                        });
                      }),
                  NavigationIcons(
                      iconText: "Filter",
                      icon: Icons.filter_list,
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
        )*/
        );
  }

  /*Widget checkInput() {
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
            color: color.backgroundColor,
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
 */ /*
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
          const Divider(color: Colors.white),
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
        ]),
      );*/

/*  */ /**
        * Function that causes a user logout inside the navigation drawer
        */ /*
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
  }*/
}
