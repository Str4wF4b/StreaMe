import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

import '../others/app_overlay.dart';
import 'home.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  ColorPalette color = ColorPalette();


  @override
  Widget build(BuildContext context) {
    /*return AppOverlay(title: "Explore", body: buildBody(),);
  }


  Widget buildBody() {
    */return Container(
    color: color.middleBackgroundColor,
    child: Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
          backgroundColor: Colors.lightBlueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        ),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => AppOverlay(title: "Home", body: HomePage(), currentPageIndex: 0,))),
        child: const Text("Go Back"),
      ),
    ),
  );
  }
}
