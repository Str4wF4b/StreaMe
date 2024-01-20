import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      //home: MyTabbedPage(),
    );
  }
}

class MyTabbedPage extends StatefulWidget {
  //const MyTabbedPage({Key key}) : super(key: key);

  @override
  _MyTabbedPageState createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'LEFT'),
    const Tab(text: 'RIGHT'),
  ];

 // TabController _tabController;

  @override
  void initState() {
    super.initState();
    //_tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    //_tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tab demo"),
        bottom: TabBar(
          //controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        //controller: _tabController,
        children: myTabs.map((Tab tab) {
          return Center(child: Text(""));
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {}, // _tabController.animateTo((_tabController.index + 1) % 2), // Switch tabs
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }
}