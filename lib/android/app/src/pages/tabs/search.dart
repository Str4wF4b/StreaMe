import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';
import '../../pages/others/filter.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import '../../utils/constants_and_values.dart';
import '../../pages/others/stream_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Utils:
  final ColorPalette _color = ColorPalette();
  final ConstantsAndValues _cav = ConstantsAndValues();

  // Instances:
  final _searchController = TextEditingController();

  // Local instances:
  String _username = "unknown User";
  late List _streams = allStreams; //temporarily

  // Database:
  User? _user = FirebaseAuth.instance.currentUser;
  final _userRepo = UserData();

  @override
  void initState() {
    super.initState();
    if (_user?.displayName != null) {
      _username = _user!
          .displayName!; // change username to User's username if not anonymous
    }

    _streams.sort((a, b) => a.title.toString().toLowerCase().compareTo(
        b.title.toString().toLowerCase())); // sorting List alphabetically
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color.backgroundColor,
      body: CustomRefreshIndicator(
        // refresh page
        onRefresh: () {
          setState(() {});
          return Future.delayed(const Duration(milliseconds: 1200));
        },
        builder: MaterialIndicatorDelegate(builder: (context, controller) {
          return Icon(
            Icons.camera,
            color: _color.backgroundColor,
            size: 30,
          );
        }),
        child: SafeArea(
          child: Container(
            color: _color.middleBackgroundColor,
            child: Column(
              children: [
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FutureBuilder(
                        future: getUserProfileData(),
                        // fetch user's profile data to get and display his username
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            UserModel user = snapshot.data as UserModel;
                            _username = user
                                .username; // if user is not anonymous (i.e. data is available) or username has been changed, change the username
                          }
                          // The info text at the top of the screen:
                          return RichText(
                            text: TextSpan(
                                text: "Hey ",
                                style: TextStyle(
                                    color: _color.bodyTextColor,
                                    fontSize: 15,
                                    height: 1.2),
                                children: [
                                  TextSpan(
                                      text: _username,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  TextSpan(
                                      text:
                                          ", \nsearch for your favourite Movies or Series and add them to your Watchlist.",
                                      style: TextStyle(
                                          fontSize: 15,
                                          height: _cav.textHeight))
                                ]),
                          );
                        }),
                  ),
                ),
                Stack(children: [
                  // The Textfield to search after Movies or Series:
                  Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 30.0, 42.0, 20.0),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(decorationThickness: 0.0),
                      // disable underline
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, size: 22),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? GestureDetector(
                                // clear user input
                                child: const Icon(Icons.close,
                                    color: Colors.blueGrey, size: 22),
                                onTap: () {
                                  _searchController.clear();
                                  FocusScope.of(context).requestFocus(
                                      FocusNode()); // Textfield outfocused
                                  searchStream(_searchController
                                      .text); // show full Streaming List again
                                })
                            : null,
                        hintText: "Movie or Series",
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(30.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(30.0)),
                        filled: true,
                        fillColor: _color.bodyTextColor,
                        isDense: true,
                      ),
                      onChanged: searchStream,
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width - 40,
                    bottom: MediaQuery.of(context).size.height - 769,
                    // The Filter icon left to the Search Textfield:
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor:
                                    _color.backgroundColor.withOpacity(0.5),
                                insetPadding: EdgeInsets.zero,
                                // full width and height of Dialog
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                // remove rounded border of Dialog
                                child: const FilterPage(),
                              );
                            });
                      },
                      child: Icon(
                        size: 22.0,
                        Icons.tune,
                        color: _color.bodyTextColor,
                      ),
                    ),
                  ),
                ]),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 3.0),
                  // The ListView of all current Streams:
                  child: ListView.builder(
                    itemCount: _streams.length,
                    itemBuilder: (context, index) {
                      final stream = _streams[index]; // get current Stream
                      return buildStreamTile(stream); // show the corresponding Stream Tile
                    },
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// A function that searches streams based on the keyword entered by the user
  /// enteredKeyword: The entered keyword of the user
  void searchStream(String enteredKeyword) {
    final suggestions = allStreams.where((stream) { // search all Streams to find one or more matches
      final streamTitle = stream.title.toLowerCase();
      final input = enteredKeyword.toLowerCase();

      return streamTitle.contains(input);
    }).toList();

    setState(() => _streams = suggestions); // show all found Streams
  }

  /// A function that displays the Stream Tile of each Movie or Series and returns the clicked Stream screen with information about the movie or series
  /// stream: The stream whose Tile is build
  Widget buildStreamTile(Streams stream) => ListTile(
        leading: CachedNetworkImage( // generate corresponding Stream image
          imageUrl: stream.image,
          key: UniqueKey(),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          placeholder: (context, url) => _cav.streamImagePlaceholder,
          errorWidget: (context, url, error) => _cav.imageErrorWidgetLittle,
        ),
        title: Text( // generate corresponding Stream text
          stream.title,
          style:
              TextStyle(color: _color.bodyTextColor, height: _cav.textHeight),
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamDetailsPage(stream: stream), // show corresponding movie or series information
            )),
      );

  /// A function that fetches the current user's data based on the email
  getUserProfileData() {
    _user = FirebaseAuth.instance.currentUser;
    final email = _user?.email;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }
}