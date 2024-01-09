import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/widgets/navigation_icons.dart';
import 'package:stream_me/android/app/src/pages/tabs/favourites.dart';
import 'package:stream_me/android/app/src/pages/tabs/search.dart';

import '../pages/others/filter_try.dart';

class StreameBottomAppBar extends StatefulWidget {
  int selectedIndex;

  StreameBottomAppBar({super.key, required this.selectedIndex});

  //int selectedIndex = 0;


  @override
  State<StreameBottomAppBar> createState() => _StreameBottomAppBarState();
}

class _StreameBottomAppBarState extends State<StreameBottomAppBar> {
  ColorPalette color = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0.0,
      color: Colors.transparent,
      child: Container(
        height: 52.0,
        width: MediaQuery.of(context).size.width,
        color: color.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              NavigationIcons(
                  iconText: "Search",
                  icon: Icons.search_outlined,
                  selected: widget.selectedIndex == 1,
                  onPressed: () {
                    widget.selectedIndex = 1;
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchPage()));
                    setState(() {

                      widget.selectedIndex = 1;
                    });
                    print(widget.selectedIndex);
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchPage()));
                    print("------------------------------------------------- ${widget.selectedIndex}");
                  }),
              NavigationIcons(
                  iconText: "Favourites",
                  icon: Icons.favorite,
                  selected: widget.selectedIndex == 2,
                  onPressed: () {
                    setState(() {

                      widget.selectedIndex = 2;
                      print(widget.selectedIndex);
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FavouritesPage()));
                    });
                  }),
              NavigationIcons(
                  iconText: "Filter",
                  icon: Icons.filter_list,
                  selected: widget.selectedIndex == 3,
                  onPressed: () {
                    setState(() {
                      widget.selectedIndex = 3;
                      print(widget.selectedIndex);
                      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FilterPage()));
                    });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
