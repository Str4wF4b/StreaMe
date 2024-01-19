import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/widgets/navigation_icons.dart';

class StreameBottomAppBar extends StatefulWidget {
  const StreameBottomAppBar({super.key, required this.selectedIndex});

  final int selectedIndex;

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
                    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SearchPage()));
                    setState(() {
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
