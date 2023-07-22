import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/model/actor_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import '../../utils/constants.dart';

class ActorDirectorDetailsPage extends StatefulWidget {
  final Actor actorDirector;

  const ActorDirectorDetailsPage({super.key, required this.actorDirector});

  @override
  State<ActorDirectorDetailsPage> createState() =>
      _ActorDirectorDetailsPageState();
}

class _ActorDirectorDetailsPageState extends State<ActorDirectorDetailsPage> {
  final ColorPalette color = ColorPalette();
  final Constants cons = Constants();

  final keyImage = GlobalKey();

  Size? sizeImage;

  @override
  Widget build(BuildContext context) {
    getSizeAndPosition();
    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: color.backgroundColor,
            //title: FittedBox(child: Text(widget.actorDirector.displayName)),
            //centerTitle: true,
            elevation: 0.0,
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1.2,
              background: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.actorDirector.image,
                    key: keyImage,
                    placeholder: (context, url) => cons.imagePlaceholderRect,
                    errorWidget: (context, url, error) => cons.imageErrorWidget,
                  )),
              //titlePadding: const EdgeInsets.only(top: 0.0), //0.0 but necessary to put title on bottom of image
              centerTitle: true,
              title: FittedBox(
                  child: Text(
                widget.actorDirector.displayName,
              )),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      actorDirectorInfo("Full Name:  ",
                          "${widget.actorDirector.firstName} ${widget.actorDirector.secondName}"),
                      const SizedBox(height: 20),
                      actorDirectorInfo("Age:  ",
                          "${widget.actorDirector.age} (${widget.actorDirector.birthday})"),
                      const SizedBox(height: 20),
                      actorDirectorInfo("Place of Birth:  ",
                          widget.actorDirector.placeOfBirth),
                      const SizedBox(height: 20),
                      LayoutBuilder(builder: (context, constraints) {
                        return /*checkForMaxLines(
                              widget.stream.plot, context, constraints);*/
                            ExpandText(widget.actorDirector.biography,
                                style: TextStyle(
                                    color: color.bodyTextColor,
                                    fontSize: 16 *
                                        1 /
                                        MediaQuery.of(context).textScaleFactor),
                                indicatorIcon: Icons.keyboard_arrow_down,
                                indicatorIconColor: Colors.grey.shade400,
                                indicatorPadding:
                                    const EdgeInsets.only(bottom: 1.0),
                                maxLines: /*MediaQuery.of(context).textScaleFactor == 1.1 ? 6 : 5*/
                                    6,
                                //TODO: !!
                                expandIndicatorStyle:
                                    ExpandIndicatorStyle.icon);
                      })
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /**
   * A function that determines the size and position of a specific Widget
   */
  void getSizeAndPosition() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox box =
            keyImage.currentContext!.findRenderObject() as RenderBox;

        setState(() {
          sizeImage = box.size;
        });
      });

  /**
   * A function that makes makes a simple row of Actor or Director information
   */
  AutoSizeText actorDirectorInfo(String label, String input) =>
      AutoSizeText.rich(
        TextSpan(
            text: label,
            style: TextStyle(
              color: color.bodyTextColor,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                  text: input,
                  style: TextStyle(
                    color: color.bodyTextColor,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ))
            ]),
        maxLines: 2,
        textAlign: TextAlign.center,
      );
}
