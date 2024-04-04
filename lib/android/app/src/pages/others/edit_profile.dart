import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/functions.dart';
import '../../pages/others/edit_profile_page.dart';

class EditProfile extends StatefulWidget {
  final Color backgroundColor;

  const EditProfile({super.key, required this.backgroundColor});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // Utils:
  final Functions _functions = Functions();

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
              // return a Edit Profile Screen if User is not anonymous, otherwise advise User to be anonymous
              child: FirebaseAuth.instance.currentUser!.isAnonymous
                  ? _functions.anonLoggedIn(context, false) // User is anonymous
                  : const EditProfilePage(), // User is not anonymous, i.e. can edit his Profile
            ),
          ),
        ],
      ),
    );
  }
}
