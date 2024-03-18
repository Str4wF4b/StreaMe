import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/auth/auth_main.dart';
import '../../utils/color_palette.dart';

import '../../pages/others/edit_profile_page.dart';

class EditProfile extends StatefulWidget {
  final Color backgroundColor;

  const EditProfile({super.key, required this.backgroundColor});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ColorPalette color = ColorPalette();

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
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                  ),
                ),
              ),
              backgroundColor: widget.backgroundColor,
              scrolledUnderElevation: 0.0,
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
              //return a Edit Profile Screen if User is not anonymous, otherwise advise User to be anonymous
              child: FirebaseAuth.instance.currentUser!.isAnonymous
                  ? anonLoggedIn() //User is anonymous
                  : const EditProfilePage(), //User is not anonymous, i.e. can edit his Profile
            ),
          ),
        ],
      ),
    );
  }

  Widget anonLoggedIn() {
    return Scaffold(
        backgroundColor: color.backgroundColor,
        body: Container(
          color: color.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 30.0),
            child: Row(
              children: [
                const Text(
                  "You are not logged in. ",
                  style: TextStyle(color: Colors.grey),
                ),
                const Text("Login or register ",
                    style: TextStyle(color: Colors.grey)),
                GestureDetector(
                  child: const Text(
                    "here",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  onTap: () async => await FirebaseAuth.instance.signOut().then(
                      (value) => Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const AuthPage()),
                          (route) => false)),
                ),
                const Text(".", style: TextStyle(color: Colors.grey))
              ],
            ),
          ),
        ));
  }
}
