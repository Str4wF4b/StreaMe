import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/components/stream_page.dart';

import '../model/stream_model.dart';

class StreamTile extends StatelessWidget {
  final Stream stream;
  final String image;
  final String title;
  final String year;
  final String pg;
  final double rating;
  final List cast;
  final List provider;

  const StreamTile(
      {super.key,
      required this.stream,
      required this.image,
      required this.title,
      required this.year,
      required this.pg,
      required this.rating,
      required this.cast,
      required this.provider});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamPage(stream: stream),
            )),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            //at start so that the title is on left side besides the image
            children: [
              Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ]),

              //Second column with 4 lines
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //all widgets below are justified on the top left of the second column
                    children: [
                      //First line: Title
                      FittedBox(
                        child: Text(
                          title,
                          style: TextStyle(
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                      ),
                      const SizedBox(height: 7.0),

                      //Second line: Year, PG and Rating
                      Row(
                        children: [
                          Text(
                            year,
                            style: TextStyle(
                                color: Colors.grey.shade300, fontSize: 13.0),
                          ),
                          const SizedBox(width: 13.0),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                    1.5, 0.0, 1.5, 0.0),
                                height: 16,
                                width: 25.5,
                                color: Colors.grey.shade400,
                                child: Text(
                                  pg,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(44, 40, 40, 1.0),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                          const SizedBox(width: 13.0),
                          Icon(Icons.star,
                              color: Colors.grey.shade300, size: 15.0),
                          Text("$rating",
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.grey.shade300)),
                        ],
                      ),
                      const SizedBox(height: 5.0),

                      //Third line: Cast
                      RichText(
                        text: TextSpan(
                            text: "Starring: ",
                            style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: getCast(cast),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ))
                            ]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5.0),

                      //Fourth line: Streaming Platforms
                      RichText(
                        text: TextSpan(
                            text: provider.isEmpty
                                ? "Not streamable at the moment."
                                : "On: ",
                            style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: provider.isEmpty
                                      ? ""
                                      : getProvider(provider),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ))
                            ]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              )
            ]));
  }

  String getCast(List list) {
    String cast = "";

    for (var actor in list) {
      if (actor != list.last) {
        cast += "$actor, ";
      } else {
        cast += actor;
      }
    }
    return cast;
  }

  String getProvider(List list) {
    String provider = "";

    for (var platform in list) {
      if (platform != list.last) {
        provider += "$platform, ";
      } else {
        provider += platform;
      }
    }
    return provider;
  }
}
