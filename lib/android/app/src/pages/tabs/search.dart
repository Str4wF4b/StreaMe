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

// Test:
import '../../pages/others/stream_details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  //TODO: If showFilter = true, show Container on the actual one within Stack

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  User? _user = FirebaseAuth.instance.currentUser;
  final _userRepo = UserData();
  late List<Streams> streams = allStreams;
  final ColorPalette _color = ColorPalette();
  final ConstantsAndValues _cav = ConstantsAndValues();
  String _username = "unknown User";
  late final List _streams = allStreams; //temporarily

  @override
  void initState() {
    super.initState();
    if (_user?.displayName != null) {
      _username = _user!.displayName!;
    }

    _streams.sort((a, b) => a.title
        .toString()
        .toLowerCase()
        .compareTo(b.title.toString().toLowerCase())); // sorting List in search alphabetically
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color.backgroundColor,
      body: CustomRefreshIndicator(
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
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            UserModel user = snapshot.data as UserModel;
                            _username = user.username;
                          }
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
                  Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 30.0, 42.0, 20.0),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(decorationThickness: 0.0),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, size: 22),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? GestureDetector(
                                child: const Icon(Icons.close,
                                    color: Colors.blueGrey, size: 22),
                                onTap: () {
                                  _searchController.clear();
                                  FocusScope.of(context).requestFocus(
                                      FocusNode()); //TextField outfocused
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
                        fillColor: Colors.grey.shade300,
                        isDense: true,
                      ),
                      onChanged: searchStream,
                    ),
                  ),
                  Positioned(
                    //padding: const EdgeInsets.only(left: 354, top: 37),
                    left: MediaQuery.of(context).size.width - 40,
                    bottom: MediaQuery.of(context).size.height -
                        769, //766 when isDense = false
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor:
                                    _color.backgroundColor.withOpacity(0.5),
                                insetPadding: EdgeInsets.zero,
                                //full width and height
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                //remove rounded border
                                child: FilterPage(),
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
                  child: ListView.builder(
                    itemCount: streams.length,
                    itemBuilder: (context, index) {
                      final stream = streams[index];
                      //widget.streams.sort((a, b) => a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
                      return buildStream(stream);
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

  /// Function that searches after a stream if a keyword is entered in the text field
  void searchStream(String enteredKeyword) {
    final suggestions = allStreams.where((stream) {
      final streamTitle = stream.title.toLowerCase();
      final input = enteredKeyword.toLowerCase();

      return streamTitle.contains(input);
    }).toList();

    setState(() => streams = suggestions);
  }

  /// Function that returns the clicked stream site with information about the movie or series
  Widget buildStream(Streams stream) => ListTile(
        leading: CachedNetworkImage(
          imageUrl: stream.image,
          key: UniqueKey(),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          placeholder: (context, url) => _cav.streamImagePlaceholder,
          errorWidget: (context, url, error) => _cav.imageErrorWidgetLittle,
        ),
        title: Text(
          stream.title,
          style:
              TextStyle(color: _color.bodyTextColor, height: _cav.textHeight),
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamDetailsPage(stream: stream),
            )),
      );

  getUserProfileData() {
    _user = FirebaseAuth.instance.currentUser;
    final email = _user?.email;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }
}
