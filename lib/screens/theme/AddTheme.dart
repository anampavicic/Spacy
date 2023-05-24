import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:spacy/screens/theme/congrast_screen.dart';
import 'package:spacy/services/card.dart';
import 'package:spacy/services/database.dart';

import '../../services/auth.dart';
import '../../services/theme.dart';
import '../utilities/background.dart';
import '../utilities/convex_app_bar.dart';
import 'add_card.dart';

class AddThemePage extends StatefulWidget {
  final String userId;

  const AddThemePage({super.key, required this.userId});

  @override
  _AddThemePageState createState() => _AddThemePageState();
}

class _AddThemePageState extends State<AddThemePage> {
  TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name = "";
  DateTime? deadline;
  final ThemeService _theme = ThemeService();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final CardService _cardService = CardService();

  String themeId = "";

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void leftButton() async {
    if (_formKey.currentState!.validate()) {
      final themeData = {
        'name': name,
        'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
        'firstDayToRepeat': Timestamp.fromDate(DateTime.now())
      };
      var themeIdNew = await _theme.addTheme(themeData);
      print('ThemeId: $themeIdNew');
      var currentUser = _authService.getCurrentUser();
      print('CurrentId: $currentUser');
      await _userService.addToUserThemes(currentUser.toString(), themeIdNew);
      print(themeData);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CongratsScreen(themeId: themeIdNew), // Navigate to AddThemePage
          ));
    }
  }

  void middleButton() async {
    if (_formKey.currentState!.validate()) {
      final themeData = {
        'name': name,
        'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
        'deleted': false
      };
      var themeIdNew = await _theme.addTheme(themeData);
      print('ThemeId: $themeIdNew');
      var currentUser = _authService.getCurrentUser();
      print('CurrentId: $currentUser');
      await _userService.addToUserThemes(currentUser.toString(), themeIdNew);
      print(themeData);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CongratsScreen(themeId: themeIdNew), // Navigate to AddThemePage
          ));
    }
  }

  void rightButton() async {
    if (_formKey.currentState!.validate()) {
      print('next');
      if (themeId == "") {
        final themeData = {
          'name': name,
          'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
          'firstDayToRepeat': Timestamp.fromDate(DateTime.now())
        };
        var themeIdNew = await _theme.addTheme(themeData);
        setState(() {
          themeId = themeIdNew;
        });
        print('ThemeId: $themeId');
        print(themeId);
        var currentUser = _authService.getCurrentUser();
        await _userService.addToUserThemes(currentUser.toString(), themeId);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCardPage(
                themeId: themeId,
                cards: [],
              ), // Navigate to AddThemePage
            ));
      } else {
        var cards = await _cardService.getCardsForTheme(themeId);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCardPage(
                themeId: themeId,
                cards: cards,
              ), // Navigate to AddThemePage
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: GradientBoxDecoration.gradientBoxDecoration,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Text(
                          'Add theme',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 8,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Name',
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.5)),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name can not be empty';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF0F2027),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50.0),
                            ),
                            child: const Text('Select Deadline',
                                style: TextStyle(fontSize: 16.0)),
                            onPressed: () {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                onChanged: (date) {},
                                onConfirm: (date) {
                                  setState(() {
                                    deadline = date;
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'If deadline is not selected the them will never finish ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: CustomConvexBottomAppBar(
              leftIcon: Icons.arrow_back_ios_new,
              middleIcon: Icons.check,
              rightIcon: Icons.arrow_forward_ios,
              leftButtonPressed: leftButton,
              middleButtonPressed: middleButton,
              rightButtonPressed: rightButton,
            )));
  }
}