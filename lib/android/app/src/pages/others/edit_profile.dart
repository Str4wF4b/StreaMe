import 'package:flutter/material.dart';

import '../../pages/others/edit_profile_page.dart';

class EditProfile extends StatefulWidget {
  final Color backgroundColor;

  const EditProfile({Key? key, required this.backgroundColor})
      : super(key: key);

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