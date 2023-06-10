import 'package:flutter/material.dart';
import 'package:spacy/models/theme.dart';
import 'package:spacy/services/theme.dart';
import 'package:spacy/services/user_card.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import '../theme/add_theme.dart';
import '../utilities/background.dart';
import '../utilities/convex_app_bar.dart';
import 'ThemeButtonList.dart';

class Home extends StatefulWidget {
  final String userId;
  final Function toggleView;

  const Home({super.key, required this.userId, required this.toggleView});

  //const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final UserService _user = UserService();
  final ThemeService _theme = ThemeService();
  final UserCardService _userCard = UserCardService();
  @override
  int _selectedIndex = 0;
  List<String> _words = ['Today', 'Active', 'All'];
  String Id = "Ana"; //delete this when you get the chance

  Future<List<SpacyTheme>> getThemes() async {
    var userId = _auth.getCurrentUser().toString();
    if (_selectedIndex == 0) {
      return _theme.getThemeForTodayNew(userId);
    }
    if (_selectedIndex == 1) {
      return _theme.getThemeForActiveNew(userId);
    }
    if (_selectedIndex == 2) {
      return _theme.getThemeForAllNew(userId);
    }
    return [];
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void leftButton() async {}

  void middleButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AddThemeToggleView()), // Navigate to AddThemePage
    );
  }

  void rightButton() {
    widget.toggleView();
  }

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
            body: ThemeButtonList(
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
