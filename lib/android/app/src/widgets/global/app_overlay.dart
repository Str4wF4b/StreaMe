import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/widgets/global/app_bar.dart';

import '../../pages/others/help.dart';
import '../../pages/tabs/home.dart';
import '../../pages/tabs/search.dart';
import '../../pages/tabs/favourites.dart';
import '../../pages/tabs/explore.dart';
import '../../pages/tabs/watchlist.dart';

class AppOverlay extends StatefulWidget {
  AppOverlay(
      {super.key,
      required this.fromHomeButton,
      required this.currentPageIndex});

  final bool fromHomeButton;
  final int currentPageIndex;

  final titles = [
    "Home",
    "Search",
    "Favourites",
    "Explore",
    "Watchlist",
    "Help"
  ];

  @override
  State<AppOverlay> createState() => _AppOverlayState();
}

/// The part of the AppBar that is the same for every page
/// includes: AppBar overlay, profile changes, menu navigation
//TODO: make appBar transparent when scrolling
class _AppOverlayState extends State<AppOverlay> {
  ColorPalette color = ColorPalette();
  int _currentPageIndex = -1;
  late final List pages;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.currentPageIndex;
    pages = [
      const HomePage(), //selectedIndex = 0
      SearchPage(), //selectedIndex = 1
      FavouritesPage(fromHomeButton: widget.fromHomeButton), //selectedIndex = 2
      ExplorePage(fromHomeButton: widget.fromHomeButton), //selectedIndex = 3
      WatchlistPage(fromHomeButton: widget.fromHomeButton), //selectedIndex = 4
      const HelpPage(), //selectedIndex = 5
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color.backgroundColor,
        appBar: StreameAppBar(title: widget.titles[_currentPageIndex]),
        body: pages[_currentPageIndex],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: color.bodyTextColor,
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: color.bodyTextColor,
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
            elevation: 0.0,
            indicatorColor: color.bodyTextColor,
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
                    icon:
                        const Icon(Icons.favorite_outline, color: Colors.grey),
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
            selectedIndex: _currentPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _currentPageIndex = index;
                ScaffoldMessenger.of(context)
                    .removeCurrentSnackBar(); //remove all snackbars when changing tabs
              });
            },
          ),
        ));
  }
}
