import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:spacy/services/card.dart';
import 'package:spacy/services/database.dart';

import '../../services/auth.dart';
import '../../services/theme.dart';
import '../utilities/background.dart';
import '../utilities/convex_app_bar.dart';

class EditThemeDetailsPage extends StatefulWidget {
  final Function toggleView;
  final Function setThemeDetails;
  final Function editThemeWithCards;
  final Function getThemeName;
  final Function getCards;

  const EditThemeDetailsPage(
      {super.key,
      required this.toggleView,
      required this.setThemeDetails,
      required this.editThemeWithCards,
      required this.getThemeName,
      required this.getCards});

  @override
  _EditThemeDetailsPageState createState() => _EditThemeDetailsPageState();
}

class _EditThemeDetailsPageState extends State<EditThemeDetailsPage> {
  TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String name = "";
  DateTime? deadline;
  final ThemeService _theme = ThemeService();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final CardService _cardService = CardService();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void leftButton() async {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void middleButton() async {
    if (_formKey.currentState!.validate()) {
      widget.setThemeDetails(name, deadline);
      widget.editThemeWithCards();
    }
  }

  void rightButton() async {
    if (_formKey.currentState!.validate()) {
      widget.setThemeDetails(name, deadline);
      setState(() {
        name = name;
      });
      widget.toggleView();
    }
  }

  @override
  void initState() {
    super.initState();
    name = widget.getThemeName();

    _nameController.text = name;
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
                          'Edit theme',
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
                            controller: _nameController,
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
