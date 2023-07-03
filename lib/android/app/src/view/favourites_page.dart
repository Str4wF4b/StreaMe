import 'package:flutter/material.dart';
import '../components/stream_page.dart';
import 'app_overlay.dart';
import 'home_page.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);
  final Color middleBackgroundColor = const Color.fromRGBO(44, 40, 40, 1.0);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    /*return AppOverlay(title: "Favourites", body: buildBody(),);
  }

  Widget buildBody() {
    */
    return Container(
        color: widget.middleBackgroundColor,
        child: DefaultTabController(
          length: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Scaffold(
                backgroundColor: widget.middleBackgroundColor,
                body: TabBar(
                  //overlayColor: MaterialStateColor,
                  //dividerColor: Colors.redAccent,

                  labelColor: Colors.grey.shade300,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  indicatorColor: Colors.deepOrangeAccent,
                  indicatorPadding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  tabs: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 3.0),
                      child: Text(
                        "Movies",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 3.0),
                      child: Text(
                        "Series",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}