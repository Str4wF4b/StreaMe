import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

import '../../auth/auth_main.dart';
import '../../pages/others/edit_profile.dart';

class StreameAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const StreameAppBar({super.key, required this.title});

  @override
  State<StreameAppBar> createState() => _StreameAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}

class _StreameAppBarState extends State<StreameAppBar> {
  ColorPalette color = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: FittedBox(child: Text(widget.title)),
      //fitting the width of the title of the screen
      centerTitle: true,
      backgroundColor: color.backgroundColor,
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
          //white background of the avatar
          backgroundColor: Colors.white,
          child: CircleAvatar(
            //the avatar that can be changed by the user
            radius: 19,
            foregroundColor: Colors.white,
            backgroundColor: color.backgroundColor,
            child: IconButton(
              icon: const Icon(Icons.person, size: 22),
              onPressed: () {
                setState(() {
                  showGeneralDialog(
                    context: context,
                    barrierColor: color.backgroundColor,
                    // Background color
                    barrierDismissible: false,
                    barrierLabel: 'Dialog',
                    transitionDuration: const Duration(milliseconds: 350),
                    pageBuilder: (_, __, ___) {
                      return EditProfile(
                          backgroundColor: color.backgroundColor);
                    },
                  );
                });
              },
            ),
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
            onPressed: () async => await FirebaseAuth.instance.signOut().then(
                (value) => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                    (route) => false)),
            icon: const Icon(Icons.logout))
      ],
    );
  }
}
