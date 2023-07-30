import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/model/actor_model.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/widgets/features/actor_director_tab.dart';
import '../../utils/color_palette.dart';
import '../../utils/constants_and_values.dart';
import '../../widgets/features/actor_director_tile.dart';

class ActorDirectorDetailsPage extends StatefulWidget {
  final Actor actorDirector;

  const ActorDirectorDetailsPage({super.key, required this.actorDirector});

  @override
  State<ActorDirectorDetailsPage> createState() =>
      _ActorDirectorDetailsPageState();
}

class _ActorDirectorDetailsPageState extends State<ActorDirectorDetailsPage>
    with TickerProviderStateMixin {
  final ColorPalette color = ColorPalette();
  final ConstantsAndValues cons = ConstantsAndValues();

  final keyImage = GlobalKey();
  Size? sizeImage;

  late final TabController _tabController =
      TabController(length: 3, vsync: this);
  late final TabController _actingTabController =
      TabController(length: 2, vsync: this);
  late final TabController _productionTabController =
      TabController(length: 2, vsync: this);
  late final TabController _directionTabController =
      TabController(length: 2, vsync: this);

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
              background: CachedNetworkImage(
                imageUrl: widget.actorDirector.image,
                fit: BoxFit.fitHeight,
                key: keyImage,
                placeholder: (context, url) => cons.imagePlaceholderRect,
                errorWidget: (context, url, error) => cons.imageErrorWidget,
              ),
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
                      }),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            //child: Padding(
                              //padding: const EdgeInsets.only(bottom: 5.0),
                              child: TabBar(
                                labelColor: color.bodyTextColor,
                                unselectedLabelColor: Colors.grey,
                                //isScrollable: true,
                                indicatorColor: Colors.deepOrangeAccent,
                                indicatorPadding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                controller: _tabController,
                                tabs: [
                                  addTab("Acting"),
                                  addTab("Production"),
                                  addTab("Direction"),
                                ],
                              ),
                            //),
                          ),
                          SizedBox(
                            height: 300,
                            //width: double.maxFinite, //all available width
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                      //child: actingTab(widget.actorDirector),
                                    child: ActorDirectorTab(actorDirector: widget.actorDirector, tabContent: widget.actorDirector.acting)
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 0.0),
                                      //child: actingTab(widget.actorDirector),
                                      child: ActorDirectorTab(actorDirector: widget.actorDirector, tabContent: widget.actorDirector.production)
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 0.0),
                                      //child: actingTab(widget.actorDirector),
                                      child: ActorDirectorTab(actorDirector: widget.actorDirector, tabContent: widget.actorDirector.directing)
                                  ),
                                ]),
                          ),
                        ],
                      )
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
        final RenderBox boxImage =
            keyImage.currentContext!.findRenderObject() as RenderBox;

        setState(() {
          sizeImage = boxImage.size;
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

  /**
   * aa
   */
  Widget addTab(String tabTitle) => Tab(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 3.0),
          child: Text(
            tabTitle,
            style: TextStyle(fontSize: 14 * MediaQuery.of(context).textScaleFactor),
          ),
        ),
      );
}
