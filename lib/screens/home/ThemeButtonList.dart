import 'package:flutter/material.dart';
import 'package:spacy/services/database.dart';

import '../cards/card_page.dart';

class ThemeButtonList extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function() getThemes;

  ThemeButtonList({required this.getThemes});

  @override
  _ThemeButtonListState createState() => _ThemeButtonListState();
}

class _ThemeButtonListState extends State<ThemeButtonList> {
  TextEditingController _textFieldController = TextEditingController();
  bool _showPopup = false;

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.getThemes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          print(snapshot.hasError);
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final themes = snapshot.data;
        if (themes != null && themes.isNotEmpty) {
          return ListView.builder(
            itemCount: themes.length,
            itemBuilder: (context, index) {
              final theme = themes[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                // Adjust the horizontal padding as needed
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CardPage(cards: []),
                          ),
                        );
                        // Perform actions when the button is pressed
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            theme['name'],
                            style: TextStyle(fontSize: 14.0),
                          ),
                          PopupMenuButton<String>(
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem<String>(
                                value: 'share',
                                child: Text('Share with Friends'),
                              ),
                              PopupMenuItem<String>(
                                value: 'archive',
                                child: Text('Archive'),
                              ),
                            ],
                            onSelected: (String value) {
                              switch (value) {
                                case 'edit':
                                  // Perform edit action
                                  break;
                                case 'share':
                                  _showSharePopup(
                                    theme['id'],
                                  );
                                  break;
                                case 'archive':
                                  // Perform archive action
                                  break;
                              }
                            },
                            icon: Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    )),
              );
            },
          );
        }

        return Center(
          child: Text('No themes found.'),
        );
      },
    );
  }

  void _showSharePopup(String themeId) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final UserService _userService = UserService();

    String email = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share with Friends'),
          content: Form(
              key: _formKey,
              child: Container(
                width: 200, // Adjust the width as needed
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _textFieldController,
                      decoration: InputDecoration(
                        hintText: 'Enter friend\'s email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Perform actions with the entered email
                          var userId =
                              await _userService.getUserIdByEmail(email);
                          await _userService.addToUserThemes(
                              userId.toString(), themeId);
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).backgroundColor,
                        // Use the background color as the button color
                        onPrimary: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
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
              )),
        );
      },
    );
  }
}
