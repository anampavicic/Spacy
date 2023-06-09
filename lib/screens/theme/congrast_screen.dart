import 'package:flutter/material.dart';
import 'package:spacy/services/database.dart';

import '../utilities/background.dart';
import '../utilities/convex_app_bar_one_button.dart';

class CongratsScreen extends StatefulWidget {
  @override
  final String themeId;

  const CongratsScreen({super.key, required this.themeId});

  _CongratsScreenState createState() => _CongratsScreenState();
}

class _CongratsScreenState extends State<CongratsScreen> {
  TextEditingController _textFieldController = TextEditingController();
  bool showTextField = false;
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  void clearFields() {
    _textFieldController.clear();
  }

  void middleButton() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GradientBoxDecoration.gradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 170),
                  Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'You have successfully added a new theme.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Color(0xFF0F2027),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        showTextField = true;
                      });
                    },
                    child: Text(
                      'Share it with friends?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (showTextField)
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _textFieldController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a friend\'s email';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter friends email',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 7.0,
                                horizontal: 10.0,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Color(0xFF0F2027),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String email = _textFieldController.text.trim();
                                var userId = await _userService
                                    .getUserIdByEmail(email)
                                    .toString();
                                await _userService.addToUserThemes(
                                    userId, widget.themeId);
                                clearFields();
                              }
                            },
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomConvexBottomAppBarOneButton(
          middleIcon: Icons.check,
          middleButtonPressed: middleButton,
        ),
      ),
    );
  }
}
