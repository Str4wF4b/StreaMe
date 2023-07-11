import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

import '../others/streamDetails.dart';
import '../others/filter.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  final searchController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  late List<Streams> streams = allStreams;

  //TODO: If showFilter = true, show Container on the actual one within Stack

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ColorPalette color = ColorPalette();


  @override
  Widget build(BuildContext context) {
    return /*AppOverlay(
      title: "Search",
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return*/
        Scaffold(
      body: Container(
        color: color.middleBackgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 38),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    //TODO: Different names (Google, Apple or Anon)
                    "Hey ${checkUsername()}, \nsearch for the newest movies and series.",
                    style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 16.0,
                        height: 1.25)),
              ),
            ),
            Stack(children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20.0, 20.0, 42.0, 20.0),
                child: TextField(
                  controller: widget.searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: widget.searchController.text.isNotEmpty
                        ? GestureDetector(
                            child:
                                const Icon(Icons.close, color: Colors.blueGrey),
                            onTap: () {
                              widget.searchController.clear();
                              FocusScope.of(context).requestFocus(
                                  FocusNode()); //TextField outfocused
                            })
                        : null,
                    hintText: "Movie or Series",
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(20.0)),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                  ),
                  onChanged: searchStream,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 354, top: 37),
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor:
                            color.middleBackgroundColor.withOpacity(0.93),
                            insetPadding: EdgeInsets.zero,
                            //full width and height
                            child: FilterPage(),
                          );
                        });
                  },
                  child: Icon(
                    size: 21.0,
                    Icons.tune,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ]),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: ListView.builder(
                itemCount: widget.streams.length,
                itemBuilder: (context, index) {
                  final stream = widget.streams[index];
                  //widget.streams.sort((a, b) => a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
                  return buildStream(stream);
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  /**
   * Function that searches after a stream if a keyword is entered in the text field
   */
  void searchStream(String enteredKeyword) {
    final suggestions = allStreams.where((stream) {
      final streamTitle = stream.title.toLowerCase();
      final input = enteredKeyword.toLowerCase();

      return streamTitle.contains(input);
    }).toList();

    setState(() => widget.streams = suggestions);
  }

  /**
   * Function that returns the clicked stream site with information about the movie or series
   */
  Widget buildStream(Streams stream) => ListTile(
        leading: Image.network(
          stream.image,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
        title: Text(
          stream.title,
          style: TextStyle(color: Colors.grey.shade300),
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamDetailsPage(stream: stream),
            )),
      );

  /**
   * Function that checks if a user is logged in and so the Username is shown, or if it's an anonymous user
   */
  String checkUsername() {
    if (widget.user?.displayName == null || widget.user?.displayName == "") {
      return "ma G"; //shown if anonymous user
    } else {
      return "${widget.user?.displayName}"; //show username
    }
  }
}
