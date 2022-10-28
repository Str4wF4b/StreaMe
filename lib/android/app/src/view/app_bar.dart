import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/view/explore_page.dart';
import 'package:stream_me/android/app/src/view/favourites_page.dart';
import 'package:stream_me/android/app/src/view/help.dart';

class MovieAppBar extends StatefulWidget {
  const MovieAppBar({Key? key, required this.title}) : super(key: key);

  final String title;
  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);

  @override
  State<MovieAppBar> createState() => _MovieAppBarState();
}

/**
 * The part of the AppBar that is the same for every page
 * includes: AppBar overlay, profile changes, menu navigation
 */
class _MovieAppBarState extends State<MovieAppBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: widget.backgroundColor,
        shape: const Border(
            //border line under AppBar
            bottom: BorderSide(
          color: Colors.white,
          width: 2.0,
        )),
        leading: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 5.0, 7.0),
          child: CircleAvatar(
            radius: 20,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.person),
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
        actions: <Widget>[
          /*CircleAvatar(
          radius: 20,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              setState(() {
                //TODO: function that does something
              });
            },
          ),
        ),*/
          /*TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          onPressed: () {
          },
          child: Icon(Icons.menu),
        ),*/
        ],
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
    child: Wrap(
        children: [
          buildListItems(Icons.travel_explore_rounded, "Explore", ExplorePage()),
          const Divider(
            color: Colors.white,
          ),
          buildListItems(Icons.local_movies_outlined, "My Movies", FavouritesPage()),
          const Divider(
            color: Colors.white,
          ),
          buildListItems(Icons.movie_outlined, "My Series", FavouritesPage()),
          const Divider(
            color: Colors.white,
          ),
          buildListItems(Icons.help_outline, "Help", HelpPage()),
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
          ),),
      onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => widget)),
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
          Expanded(
            flex: 1,
            child: SizedBox.expand(
              child: Row(
                children: <Widget>[
                  const Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 90.0, 0.0, 0.0),
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )),
                  const Spacer(),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 20.0, 5.0, 0.0),
                        /*child: Ink(
                      decoration: ShapeDecoration(
                        color: Colors.red.withOpacity(0.3),
                        shape: const CircleBorder(),
                      ),*/
                        child: IconButton(
                          //alignment: Alignment.centerRight,
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        //), Ink
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: SizedBox.expand(
              child: EditProfilePage(backgroundColor: widget.backgroundColor),
            ),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.backgroundColor})
      : super(key: key);
  final Color backgroundColor;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
          backgroundColor: widget.backgroundColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,)
            )
          ],
        ),*/
      body: Container(
        color: widget.backgroundColor,
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                //centering the profile picture
                child: Stack(
                  children: [
                    Container(
                      //container for profile picture
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                          //border around profile picture
                          width: 3,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.white.withOpacity(0.3),
                          )
                        ],
                        shape: BoxShape.circle,
                        //profile picture in circle shape
                        image: const DecorationImage(
                            //default profile picture
                            fit: BoxFit.cover,
                            image:
                                AssetImage("assets/blank-profile-picture.png")),
                      ),
                    ),
                    Positioned(
                        //positioning the "change picture" item
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            border: Border.all(
                              //border around profile picture
                              width: 1,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                color: Colors.white.withOpacity(0.3),
                              )
                            ],
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                //spacing between profile picture and text field
                height: 46,
              ),
              buildTextFields("Username", "Enter new Username here", false),
              buildTextFields("Full Name", "Enter new Full Name here", false),
              buildTextFields("E-Mail", "Enter new E-Mail address here", false),
              buildTextFields("Password", "Enter new Password here", true),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //setting space between buttons cancel and save
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        16.0, 10.0, 0.0, 0.0),
                    child: OutlinedButton(
                      //styling of cancel button
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                      ),
                      onPressed: () {
                        //TODO: Delete input function
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 10.0, 16.0, 0.0),
                    child: ElevatedButton(
                        //styling of save button
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                        ),
                        onPressed: () {
                          //TODO: Save input (into DB also)
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white,
                          ),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTextFields(
      String labelText, String placeholder, bool isPassword) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 35.0),
      child: TextField(
        //text fields for input
        style: const TextStyle(
          //style of written input
          color: Colors.blueAccent,
        ),
        obscureText: isPassword ? showPassword : false,
        decoration: InputDecoration(
            //style of label
            suffixIcon: isPassword //show password icon
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword =
                            !showPassword; //switch between showing and not showing password
                      });
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //input labels are always open
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            hintText: placeholder,
            //style of placeholder
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Colors.blueGrey,
            )),
      ),
    );
  }
}
