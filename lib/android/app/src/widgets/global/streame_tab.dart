import 'package:flutter/material.dart';

class StreaMeTab extends StatelessWidget {
  final String tabTitle;
  final bool isWatchlist;

  const StreaMeTab(
      {super.key, required this.tabTitle, required this.isWatchlist});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding:
          isWatchlist ? const EdgeInsets.only(left: 15.0, right: 15.0) : null,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          tabTitle,
          style: TextStyle(
            fontSize: MediaQuery.textScalerOf(context).scale(12.3965),
          ),
        ),
      ),
    );
  }
}
