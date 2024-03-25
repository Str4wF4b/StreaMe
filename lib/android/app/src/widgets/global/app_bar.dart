import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';
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
  final ColorPalette _color = ColorPalette();

  // Database:
  User? _user = FirebaseAuth.instance.currentUser;
  final _userRepo = UserData();
  CachedNetworkImageProvider? _profilePicture;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: FittedBox(
          child: Text(
        widget.title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      )),
      centerTitle: true,
      backgroundColor: _color.backgroundColor,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      leading: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 5.0, 7.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: CircleAvatar(
            // the avatar that can be changed by the user
            radius: 19,
            foregroundColor: Colors.white,
            backgroundColor: _color.backgroundColor,
            child: FutureBuilder(
              future: getUserProfileData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // data is completely fetched
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data as UserModel;
                    _profilePicture = CachedNetworkImageProvider(user.imageUrl);

                    return GestureDetector(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          user.imageUrl))))),
                      onTap: () {
                        setState(() {
                          showProfileDialog();
                        });
                      },
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.person, size: 22),
                      onPressed: () {
                        setState(() {
                          showProfileDialog();
                        });
                      },
                    );
                  }
                } else {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(60.0),
                    child: _profilePicture != null
                        ? Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: _profilePicture as ImageProvider)))
                        : Container(
                            color: _color
                                .backgroundColor), // if the current profile picture is not loaded yet, return black background
                  );
                }
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
            icon: const Icon(Icons.logout, color: Colors.white))
      ],
    );
  }

  /// A function that fetches the current user's data
  getUserProfileData() {
    _user = FirebaseAuth.instance.currentUser;
    final email = _user?.email;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }

  /// A function that shows the Edit Profile Dialog Screen
  void showProfileDialog() {
    showGeneralDialog(
      context: context,
      barrierColor: _color.backgroundColor,
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: const Duration(milliseconds: 0),
      pageBuilder: (_, __, ___) {
        return EditProfile(backgroundColor: _color.backgroundColor);
      },
    );
  }
}
