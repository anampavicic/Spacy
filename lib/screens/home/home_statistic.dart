import 'package:flutter/material.dart';
import 'package:spacy/screens/home/statistic_theme_button_list.dart';

import '../../models/theme.dart';
import '../../services/theme.dart';
import '../add theme/add_theme.dart';
import '../utilities/background.dart';
import '../utilities/convex_app_bar.dart';

class HomeStatistic extends StatefulWidget {
  final String userId;
  final Function toggleView;

  const HomeStatistic(
      {super.key, required this.userId, required this.toggleView});

  @override
  State<HomeStatistic> createState() => _HomeStatisticState();
}

class _HomeStatisticState extends State<HomeStatistic> {
  final ThemeService _theme = ThemeService();

  Future<List<SpacyTheme>> getThemes() async {
    var themes = await _theme.getThemesForStatistic(widget.userId);
    if (_selectedIndex == 0) {
      themes.sort((a, b) => a.percentOfSolvedCardsForUser!
          .compareTo(b.percentOfSolvedCardsForUser as num));
    }
    if (_selectedIndex == 1) {
      themes.sort((a, b) => b.percentOfSolvedCardsForUser!
          .compareTo(a.percentOfSolvedCardsForUser as num));
    }
    return themes;
  }

  @override
  int _selectedIndex = 0;
  List<String> _words = ['Best', 'Worst'];
  void leftButton() async {
    widget.toggleView();
  }

  void middleButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AddThemeToggleView()), // Navigate to AddThemePage
    );
  }

  void rightButton() {}

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: GradientBoxDecoration.gradientBoxDecoration,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _words.map((word) {
                    int index = _words.indexOf(word);
                    bool isSelected = _selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  word.toUpperCase(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )),
            body: StatisticThemeButtonList(
              getThemes: getThemes,
            ),
            bottomNavigationBar: CustomConvexBottomAppBar(
              rightIcon: Icons.article,
              middleIcon: Icons.add,
              leftIcon: Icons.bar_chart,
              rightButtonPressed: rightButton,
              middleButtonPressed: middleButton,
              leftButtonPressed: leftButton,
            )));
  }
}
