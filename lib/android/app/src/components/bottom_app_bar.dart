import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/components/navigation_icons.dart';
import 'package:stream_me/android/app/src/view/favourites_page.dart';
import 'package:stream_me/android/app/src/view/search_page.dart';

import '../view/filter_page.dart';

class StreameBottomAppBar extends StatefulWidget {
  int selectedIndex;

  StreameBottomAppBar({Key? key, required this.selectedIndex}) : super(key: key);

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);
  //int selectedIndex = 0;


  @override
  State<StreameBottomAppBar> createState() => _StreameBottomAppBarState();
}

class _StreameBottomAppBarState extends State<StreameBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0.0,
      color: Colors.transparent,
      child: Container(
        height: 52.0,
        width: MediaQuery.of(context).size.width,
        color: widget.backgroundColor,
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
