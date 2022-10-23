import 'package:flutter/material.dart';

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
                    return ProfileChanges(
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
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          onPressed: () {},
          child: const Icon(Icons.menu),
        ),
      ],
    ));
  }
}

class ProfileChanges extends StatefulWidget {
  const ProfileChanges({Key? key, required this.backgroundColor})
      : super(key: key);

  final Color backgroundColor;

  @override
  State<ProfileChanges> createState() => _ProfileChangesState();
}

class _ProfileChangesState extends State<ProfileChanges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: SizedBox.expand(
              child: IconButton(
                alignment: Alignment.centerRight,
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 5,
            child: SizedBox.expand(child: FlutterLogo()),
          ),
        ],
      ),
    );
  }
}
