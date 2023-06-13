import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_me/android/app/src/view/explore_page.dart';
import 'package:stream_me/android/app/src/view/favourites_page.dart';
import 'package:stream_me/android/app/src/view/help.dart';
import 'package:stream_me/android/app/src/view/login_page.dart';
import 'package:stream_me/android/app/src/view/login_page_alpha.dart';
import 'package:stream_me/android/app/src/view/search_page.dart';

import '../components/edit_profile_page.dart';
import '../services/auth_page.dart';
import 'filter_page.dart';
import 'home_page.dart';

class MovieAppBar extends StatefulWidget {
  const MovieAppBar({Key? key, required this.title, required this.body})
      : super(key: key);

  final String title;
  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);

  final Widget body;

  @override
  State<MovieAppBar> createState() => _MovieAppBarState();
}

/**
 * The part of the AppBar that is the same for every page
 * includes: AppBar overlay, profile changes, menu navigation
 */
//TODO: make appBar transparent when scrolling
class _MovieAppBarState extends State<MovieAppBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: widget.backgroundColor,
        elevation: 0.0,
        /*shape: const Border(
            //border line under AppBar
            bottom: BorderSide(
          color: Colors.white,
          width: 2.0,
        )),*/
        leading: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 5.0, 7.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 19,
              foregroundColor: Colors.white,
              backgroundColor: widget.backgroundColor,
              child: IconButton(
                icon: const Icon(Icons.person, size: 22),
                onPressed: () {
                  setState(() {
                    showGeneralDialog(
                      context: context,
                      barrierColor: widget.backgroundColor,
                      // Background color
                      barrierDismissible: false,
                      barrierLabel: 'Dialog',
                      transitionDuration: const Duration(milliseconds: 350),
                      pageBuilder: (_, __, ___) {
                        return EditProfile(
                            backgroundColor: widget.backgroundColor);
                      },
                    );
                  });
                },
              ),
            ),
          ),
        ),
        actions: const <Widget>[],
      ),
      endDrawer: Drawer(
        backgroundColor: widget.backgroundColor,
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
      bottomNavigationBar: BottomAppBar(
        color: widget.backgroundColor,
        child: Container(
          //color: Color.fromRGBO(180, 180, 180, 1.0),
          height: 52.0,
          color: widget.backgroundColor,
          /*decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
            color: Color.fromRGBO(200, 200, 200, 1.0),
          ),*/
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[ //the icons of the BottomAppBar
              addBottomIcons(Icons.search_outlined, "Search", const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0), SearchPage()),
              addBottomIcons(Icons.favorite, "Saved", EdgeInsets.zero, FavouritesPage()),
              addBottomIcons(Icons.filter_list_outlined, "Filter", const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0), FilterPage()),
            ],
          ),
        ),
      ),
      body: widget.body,
    );
  }

  /**
   * Function that builds the icons of the BottomAppBar
   */
  //TODO: make icons selected if selected and unselected if not
  Padding addBottomIcons(IconData icon, String iconLabel, EdgeInsets insets, StatefulWidget page) {
    return Padding(
      padding: insets,
      child: SizedBox.fromSize(
        size: const Size(66, 66),
        child: ClipOval(
          child: Material(
            //color: const Color.fromRGBO(200, 200, 200, 1.0),
            color: widget.backgroundColor,
            child: InkWell(
              onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => page)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    icon,
                    color: Colors.white,), // <-- Icon
                  Text(
                      iconLabel,
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
          buildListItems(Icons.home, "Home", const HomePage()),
          const Divider(
            color: Colors.white,
          ),
          buildListItems(
              Icons.travel_explore_rounded, "Explore", const ExplorePage()),
          const Divider(
            color: Colors.white,
          ),
          buildListItems(
              Icons.local_movies_outlined, "My Movies", const FavouritesPage()),
          const Divider(
            color: Colors.white,
          ),
          buildListItems(
              Icons.movie_outlined, "My Series", const FavouritesPage()),
          const Divider(
            color: Colors.white,
          ),
          buildListItems(Icons.help_outline, "Help", const HelpPage()),
          const Divider(
            color: Colors.white,
          ),
          buildLogoutItem(Icons.logout_outlined, "Logout"),
        ]),
      );

  /**
   * Function that determines the style of an element of the navigation drawer
   */
  ListTile buildListItems(IconData icon, String label, StatefulWidget widget) {
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
      onTap: () => Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => widget)),
    );
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
      onTap: () async => await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthPage()), (route) => false))
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.backgroundColor})
      : super(key: key);

  final Color backgroundColor;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Column(
        children: <Widget>[
          AppBar(
              title: const Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
              ),
              backgroundColor: widget.backgroundColor,
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  //alignment: Alignment.centerRight,
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ]),
          Expanded(
            flex: 5,
            child: SizedBox.expand(
              child: EditProfilePage(
                backgroundColor: widget.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
