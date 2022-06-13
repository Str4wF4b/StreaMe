import 'package:flutter/material.dart';

import '../controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  final String title = "Login";
  final String subtitle = "Do something";

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LoginController logCon = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.subtitle),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FloatingActionButton(onPressed: () {
                setState(() {
                  logCon.decrementCounter;
                });
              },
              tooltip: "Decrement",
              child: Icon(Icons.remove)),
              Text(logCon!=null ? '${logCon.counter}' : "Hello"),

              FloatingActionButton(onPressed: () {
                setState(() {
                  logCon.incrementCounter;
                });
              },
              tooltip: "Increment",
              child: Icon(Icons.add))
            ],
          )],
        )
      )
    );
  }
}