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
  const AppOverlay(
      {super.key,
      required this.fromHomeButton,
      required this.currentPageIndex});

  final bool fromHomeButton;
  final int currentPageIndex;

  @override
  State<AppOverlay> createState() => _AppOverlayState();
}


class _AppOverlayState extends State<AppOverlay> {
  // Utils:
  final ColorPalette _color = ColorPalette();

  // Local instances:
  int _currentPageIndex = -1; // index that switches between Tabs
  late final List _pages; // contains all pages
  final _titles = [
    "Home",
    "Search",
    "Favourites",
    "Explore",
    "Watchlist",
    "Help"
  ]; // contains the pages' titles

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.currentPageIndex;
    _pages = [
      const HomePage(), // currentPageIndex = 0
      const SearchPage(), // currentPageIndex = 1
      FavouritesPage(fromHomeButton: widget.fromHomeButton), // currentPageIndex = 2
      ExplorePage(fromHomeButton: widget.fromHomeButton), // currentPageIndex = 3
      WatchlistPage(fromHomeButton: widget.fromHomeButton), // currentPageIndex = 4
      const HelpPage(), // currentPageIndex = 5
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _color.backgroundColor,
        appBar: StreameAppBar(title: _titles[_currentPageIndex]), // App Bar
        body: _pages[_currentPageIndex], // switching between pages
        // Bottom Navigation App Bar:
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: _color.bodyTextColor,
            labelTextStyle: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: _color.bodyTextColor,
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
            backgroundColor: _color.backgroundColor,
            elevation: 0.0,
            indicatorColor: _color.bodyTextColor,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(milliseconds: 800),
            destinations: [
              // Tab "Home":
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: NavigationDestination(
                    icon: const Icon(Icons.home_outlined, color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.home,
                      color: _color.backgroundColor,
                    ),
                    label: "Home"),
              ),
              // Tab "Search":
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: NavigationDestination(
                    icon: const Icon(Icons.search_outlined, color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.search,
                      color: _color.backgroundColor,
                    ),
                    label: "Search"),
              ),
              // Tab "Favourites":
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: NavigationDestination(
                    icon:
                        const Icon(Icons.favorite_outline, color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.favorite,
                      color: _color.backgroundColor,
                    ),
                    label: "Favourites"),
              ),
              // Tab "Explore":
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: NavigationDestination(
                    icon: const Icon(Icons.travel_explore_outlined,
                        color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.travel_explore,
                      color: _color.backgroundColor,
                    ),
                    label: "Explore"),
              ),
              // Tab "Watchlist":
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: NavigationDestination(
                    icon: const Icon(Icons.list_rounded, color: Colors.grey),
                    selectedIcon: Icon(
                      Icons.list_rounded,
                      color: _color.backgroundColor,
                    ),
                    label: "Watchlist"),
              )
            ],
            selectedIndex: _currentPageIndex, // currently selected index
            onDestinationSelected: (int index) {
              setState(() {
                _currentPageIndex = index;
                ScaffoldMessenger.of(context)
                    .removeCurrentSnackBar(); // remove all Snackbars when changing tabs
              });
            },
          ),
        ));
  }
}
