import 'package:flutter/material.dart';
import 'package:spacy/screens/home/home.dart';

import 'home_statistic.dart';

class HomeWrapper extends StatefulWidget {
  final String userId;
  const HomeWrapper({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  bool isStatisticPage = false;

  void toggleView() {
    setState(() {
      isStatisticPage = !isStatisticPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isStatisticPage) {
      return Container(
        child: HomeStatistic(userId: widget.userId, toggleView: toggleView),
      );
    } else {
      return Container(
        child: Home(userId: widget.userId, toggleView: toggleView),
      );
    }
  }
}
