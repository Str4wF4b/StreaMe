import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_me/android/app/src/view/explore_page.dart';
import 'package:stream_me/android/app/src/view/favourites_page.dart';
import 'package:stream_me/android/app/src/view/help.dart';
import 'package:stream_me/android/app/src/view/search_page.dart';

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
              addBottomIcons(Icons.search_outlined, "Search", const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0), const SearchPage()),
              addBottomIcons(Icons.favorite, "Saved", EdgeInsets.zero, const FavouritesPage()),
              addBottomIcons(Icons.filter_list_outlined, "Filter", const EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0), const FilterPage()),
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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.backgroundColor})
      : super(key: key);
  final Color backgroundColor;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool showPassword = false;
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
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
                        image: DecorationImage(
                            //default profile picture
                            fit: BoxFit.cover,
                            image: selectImage()),
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
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomProfileSheet()),
                                backgroundColor: widget.backgroundColor,
                              );
                            },
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
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
                        backgroundColor: Colors.red.shade500,
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

  Widget bottomProfileSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            'Choose photo from ...',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            //spacing
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 5.0, 0.0, 0.0),
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.cyan,
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  label: const Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.cyan,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 16.0, 0.0),
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.image,
                    size: 30,
                    color: Colors.cyan,
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  label: const Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.cyan,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
        source:
            source); //TODO: maybe change function getImage to pickImage if it works
    setState(() {
      _imageFile = pickedFile;
    });
  }

  ImageProvider<Object> selectImage() {
    return _imageFile == null
        ? const AssetImage("assets/blank-profile-picture.png")
        : FileImage(File(_imageFile!.path)) as ImageProvider;
  }

/*  Future<bool?> showCancelDialog() => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Yes')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('No')),
          ],
        ),
      );*/
}
