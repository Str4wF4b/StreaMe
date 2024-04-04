import 'package:auto_size_text/auto_size_text.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_me/android/app/src/model/actor_model.dart';
import '../../widgets/features/actor_director_tab.dart';
import '../../utils/color_palette.dart';
import '../../utils/constants_and_values.dart';
import '../../widgets/global/streame_tab.dart';

class ActorDirectorDetailsPage extends StatefulWidget {
  final Actor actorDirector;

  const ActorDirectorDetailsPage({super.key, required this.actorDirector});

  @override
  State<ActorDirectorDetailsPage> createState() =>
      _ActorDirectorDetailsPageState();
}

class _ActorDirectorDetailsPageState extends State<ActorDirectorDetailsPage>
    with TickerProviderStateMixin {
  // Utils:
  final ColorPalette _color = ColorPalette();
  final ConstantsAndValues _cav = ConstantsAndValues();

  // Instances:
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  // Local instances:
  final _keyImage = GlobalKey();

  @override
  Widget build(BuildContext context) {
    readjustTabHeight();
    final sliverWidth = MediaQuery.of(context).size.width;

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
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: _color.backgroundColor,
              elevation: 0.0,
              scrolledUnderElevation: 0.0,
              leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context)),
              pinned: true,
              expandedHeight: MediaQuery.of(context).size.height * 0.375,
              // Sliver effect of actor's and director's picture with their name:
              flexibleSpace: Container(
                margin: EdgeInsets.only(
                    left: sliverWidth * 0.223, right: sliverWidth * 0.223),
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, bottom: 15.0),
                    expandedTitleScale: 1.2,
                    centerTitle: true,
                    title: FittedBox(
                      child: Text(
                        widget.actorDirector.displayName,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ), //FittedBox(
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.actorDirector.image,
                          // the image of the actor / director
                          fit: BoxFit.fitHeight,
                          key: _keyImage,
                          placeholder: (context, url) =>
                              _cav.actorDirectorPlaceholder,
                          errorWidget: (context, url, error) =>
                              _cav.imageErrorWidget,
                        ),
                        Container(
                          // faded text background effect
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                  colors: [
                                Colors.black38.withOpacity(0.0),
                                Colors.black38,
                                Colors.black38,
                                Colors.black38.withOpacity(0.0),
                              ],
                                  stops: const [
                                0.82,
                                0.88,
                                0.92,
                                0.98
                              ])),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // The actor / director information below their picture:
            SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      // Full Name:
                      actorDirectorInfo("Full Name:  ",
                          "${widget.actorDirector.firstName} ${widget.actorDirector.secondName}"),
                      const SizedBox(height: 20),
                      // Age:
                      actorDirectorInfo("Age:  ",
                          "${getAge(widget.actorDirector.birthday)} (${widget.actorDirector.birthday})"),
                      const SizedBox(height: 20),
                      // Birthplace:
                      actorDirectorInfo("Place of Birth:  ",
                          widget.actorDirector.placeOfBirth),
                      const SizedBox(height: 20),
                      // Actor / Director Biography:
                      LayoutBuilder(builder: (context, constraints) {
                        return ExpandText(widget.actorDirector.biography,
                            style: TextStyle(
                                color: _color.bodyTextColor,
                                fontSize:
                                    MediaQuery.textScalerOf(context).scale(16),
                                height: _cav.textHeight),
                            indicatorIcon: Icons.keyboard_arrow_down,
                            indicatorIconColor: Colors.grey.shade400,
                            indicatorPadding:
                                const EdgeInsets.only(bottom: 1.0),
                            maxLines: 6,
                            expandIndicatorStyle: ExpandIndicatorStyle.icon);
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
                            // TabBar with the actor's / director's Acting, Production and Direction career
                            child: TabBar(
                              physics: const ClampingScrollPhysics(),
                              dividerHeight: 0.0,
                              labelColor: _color.backgroundColor,
                              unselectedLabelColor: Colors.grey,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: _color.bodyTextColor,
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
                          ),
                          SizedBox(
                            height: setTabHeight(
                                widget.actorDirector, _tabController.index),
                            child: AutoScaleTabBarView(
                                controller: _tabController,
                                children: [
                                  // Content of "Acting"-Tab:
                                  ActorDirectorTab(
                                      actorDirector: widget.actorDirector,
                                      tabContent: widget.actorDirector.acting),
                                  // Content of "Production"-Tab:
                                  ActorDirectorTab(
                                      actorDirector: widget.actorDirector,
                                      tabContent:
                                          widget.actorDirector.production),
                                  // Content of "Direction"-Tab:
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

  /// A function that automatically sets the exactly needed height of each Tab
  void readjustTabHeight() => WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });

  /// A function that generates a row of Actor or Director information
  /// label: The constant label of the information
  /// input: The different information of each actor or director
  AutoSizeText actorDirectorInfo(String label, String input) =>
      AutoSizeText.rich(
        TextSpan(
            text: label,
            style: TextStyle(
              color: _color.bodyTextColor,
              fontSize: 17,
            ),
            children: [
              TextSpan(
                  text: input,
                  style: TextStyle(
                    color: _color.bodyTextColor,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ))
            ]),
        maxLines: 2,
        textAlign: TextAlign.center,
      );

  /// A function that adds the 3 tabs for each Actor / Director
  /// tabTitle: The title of the tab (Acting, Production or Direction)
  /// tabIndex: The index of the tab (0, 1 or 2)
  Widget addTab(String tabTitle, int tabIndex) {
    return Tab(
        child: StreaMeTab(
      tabTitle: tabTitle,
      tabIndex: tabIndex,
      tabController: _tabController,
      isWatchlist: false,
    ));
  }

  /// A function that calculates the current age for a person
  /// actorAge: The birth date (and death date) of a person
  int getAge(String actorAge) {
    int age = 0;

    String actorDay = actorAge.substring(0, 2); // index 0 and 1: day (2 is ".")
    String actorMonth =
        actorAge.substring(3, 5); // index 3 and 4: month (5 is ".")
    String actorYear = actorAge.substring(6); // index 6 and rest: year
    String actorBirthday =
        '$actorDay-$actorMonth-$actorYear'; // transform day, month and year into valid date format String
    DateTime actorBirthdayDateTime = DateFormat('dd-MM-yyyy')
        .parse(actorBirthday); // generate date format DateFormat

    // Calculate age:
    if (!actorAge.contains("†")) {
      // if person is not dead
      if (actorBirthdayDateTime.month <
              DateTime.now()
                  .month || // if month is lower than current month or ...
          (actorBirthdayDateTime.month == DateTime.now().month &&
              actorBirthdayDateTime.day <= DateTime.now().day)) {
        // ... if months are equal and day is lower or equal than current day
        age = DateTime.now().year -
            actorBirthdayDateTime.year; // calculate normally
      } else {
        age = DateTime.now().year -
            actorBirthdayDateTime.year -
            1; // calculate additional -1 because birthday hasn't been yet
      }
    } else {
      String deathDay =
          actorAge.substring(14, 16); // index 14 and 15: death day (16 is ".")
      String deathMonth = actorAge.substring(
          17, 19); // index 17 and 19: death month (20 is ".")
      String deathYear = actorAge.substring(20); // index 20 and rest: year
      String actorDeathDate =
          '$deathDay-$deathMonth-$deathYear'; // transform death day, death month and death year into valid date format String
      DateTime actorDeathDateTime = DateFormat('dd-MM-yyyy')
          .parse(actorDeathDate); // generate date format DateFormat

      // Calculate age till death:
      if (actorDeathDateTime.month <
              actorBirthdayDateTime
                  .month || // if month is lower than current month or ...
          (actorDeathDateTime.month == actorBirthdayDateTime.month &&
              actorDeathDateTime.day <= actorBirthdayDateTime.day)) {
        // ... if months are equal and day is lower or equal than current day
        age = actorDeathDateTime.year -
            actorBirthdayDateTime.year; // calculate normally
      } else {
        age = actorDeathDateTime.year -
            actorBirthdayDateTime.year -
            1; // calculate additional -1 because birthday hasn't been reached
      }
    }

    return age;
  }

  /// A function that sets the height of a tab by fetching the movies and series list for each tab (Acting, Production and Direction)
  /// actorDirector: The current actor or director
  /// tab: The index of the tab (0, 1 or 2)
  double setTabHeight(Actor actorDirector, int tabIndex) {
    double tabHeight = 0;
    List? movies;
    List? series;
    if (tabIndex == 0) {
      movies = actorDirector.acting['Movies'];
      series = actorDirector.acting['Series'];
    }
    if (tabIndex == 1) {
      movies = actorDirector.production['Movies'];
      series = actorDirector.production['Series'];
    }
    if (tabIndex == 2) {
      movies = actorDirector.directing['Movies'];
      series = actorDirector.directing['Series'];
    }
    tabHeight = getTabHeight(movies ?? [], series ?? []);
    return tabHeight;
  }

  /// A function that decides whether the height of a tab is 530, 350 or 160 depending on the content of the lists
  /// movies: The list of movies a person has acted in, produced or directed
  /// series: The list of series a person has acted in, produced or directed
  double getTabHeight(List movies, List series) {
    if (movies.isNotEmpty && series.isNotEmpty) {
      return 530; // max height if movies and series lists have input
    } else if (movies.isNotEmpty &&
            series.isEmpty ||
        series.isNotEmpty && movies.isEmpty) {
      return 350; // mid height if one of the lists is empty
    } else {
      return 160; // min height if both lists are empty
    }
  }
}