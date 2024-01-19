import 'package:auto_size_text/auto_size_text.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_me/android/app/src/model/actor_model.dart';
import 'package:stream_me/android/app/src/widgets/features/actor_director_tab.dart';
import '../../utils/color_palette.dart';
import '../../utils/constants_and_values.dart';
import '../../widgets/global/streame_tab.dart';
import '../../widgets/global/streame_refresh.dart';

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

  @override
  Widget build(BuildContext context) {
    getSizeAndPosition();
    final sliverWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: StreameRefresh(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: color.backgroundColor,
              //title: FittedBox(child: Text(widget.actorDirector.displayName)),
              //centerTitle: true,
              elevation: 0.0,
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.375,//298,
              flexibleSpace: Container(
                margin: EdgeInsets.only(left: sliverWidth * 0.223, right: sliverWidth * 0.223),
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FlexibleSpaceBar(
                    expandedTitleScale: 1.2,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.actorDirector.image,
                          fit: BoxFit.fitHeight,
                          key: keyImage,
                          placeholder: (context, url) => cons.actorDirectorPlaceholder,
                          errorWidget: (context, url, error) => cons.imageErrorWidget,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                    Colors.grey.withOpacity(0.0), // or black
                                    Colors.black87, // or black54
                                  ],
                                  stops: const [
                                    0.8, // or 0.77
                                    1.0
                                  ])),
                        )
                      ],
                    ),
                    //titlePadding: const EdgeInsets.only(top: 0.0), //0.0 but necessary to put title on bottom of image
                    centerTitle: true,
                    title: FittedBox(child: Text(widget.actorDirector.displayName), //FittedBox(
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      actorDirectorInfo("Full Name:  ",
                          "${widget.actorDirector.firstName} ${widget.actorDirector.secondName}"),
                      const SizedBox(height: 20),
                      actorDirectorInfo("Age:  ",
                          "${getAge(widget.actorDirector.birthday)} (${widget.actorDirector.birthday})"),
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
                                  fontSize: MediaQuery.textScalerOf(context).scale(16)
                                ),

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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(
                            thickness: 0.2,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerLeft,
                            //child: Padding(
                            //padding: const EdgeInsets.only(bottom: 5.0),
                            child: TabBar(
                              physics: const ClampingScrollPhysics(),
                              labelColor: color.backgroundColor,
                              unselectedLabelColor: Colors.grey,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: color.bodyTextColor,
                              ),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorPadding:
                                  const EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 8.0),
                              controller: _tabController,
                              tabs: [
                                addTab("Acting", 0),
                                addTab("Production", 1),
                                addTab("Direction", 2),
                              ],
                            ),
                            //),
                          ),
                          SizedBox(
                            height: setTabHeight(
                                widget.actorDirector, _tabController.index),
                            child: AutoScaleTabBarView(
                                controller: _tabController,
                                children: [
                                  ActorDirectorTab(
                                      actorDirector: widget.actorDirector,
                                      tabContent: widget.actorDirector.acting),
                                  ActorDirectorTab(
                                      actorDirector: widget.actorDirector,
                                      tabContent:
                                          widget.actorDirector.production),
                                  ActorDirectorTab(
                                      actorDirector: widget.actorDirector,
                                      tabContent:
                                          widget.actorDirector.directing),
                                ]),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  /// A function that determines the size and position of a specific Widget
  void getSizeAndPosition() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox boxImage =
            keyImage.currentContext!.findRenderObject() as RenderBox;

        setState(() {
          sizeImage = boxImage.size;
        });
      });

  /// A function that makes makes a simple row of Actor or Director information
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

  /// a function that adds the look of a tab
  Widget addTab(String tabTitle, int tabIndex) => Tab(
          child: StreaMeTab(
        tabTitle: tabTitle,
        tabIndex: tabIndex,
        tabController: _tabController,
        isWatchlist: false,
      ));

  /// a function that
  int getAge(String actorAge) {
    int age = 0;

    String actorDay = actorAge.substring(0, 2);
    String actorMonth = actorAge.substring(3, 5);
    String actorYear = actorAge.substring(6);
    String actorBirthday = '$actorDay-$actorMonth-$actorYear';
    DateTime actorBirthdayDateTime =
        DateFormat('dd-MM-yyyy').parse(actorBirthday);

    if (actorBirthdayDateTime.month < DateTime.now().month ||
        (actorBirthdayDateTime.month == DateTime.now().month &&
            actorBirthdayDateTime.month <= DateTime.now().month)) {
      age = DateTime.now().year - actorBirthdayDateTime.year;
    } else {
      age = DateTime.now().year - actorBirthdayDateTime.year - 1;
    }

    //TODO: Check for age for dead people

    return age;
  }

  /// a function that individually sets the height of a tab by calling the movies and series list for each tab
  double setTabHeight(Actor actorDirector, int tab) {
    double tabHeight = 0;
    List? movies;
    List? series;
    if (tab == 0) {
      movies = actorDirector.acting['Movies'];
      series = actorDirector.acting['Series'];

    }
    if (tab == 1) {
      movies = actorDirector.production['Movies'];
      series = actorDirector.production['Series'];
    }
    if (tab == 2) {
      movies = actorDirector.directing['Movies'];
      series = actorDirector.directing['Series'];
    }
    tabHeight = getTabHeight(movies ?? [], series ?? []);
    return tabHeight;
  }

  /// a function that decides whether the height of a tab is 530, 350 or 160 depending on empty movies and series lists
  double getTabHeight(List movies, List series) {
    if (movies.isNotEmpty && series.isNotEmpty) {
      //max height if movies and series list has input
      return 530;
    } else if (movies.isNotEmpty &&
            series.isEmpty || //mid height if one of the lists is empty
        series.isNotEmpty && movies.isEmpty) {
      return 350;
    } else {
      //min height if both lists are empty
      return 160;
    }
  }
}
