import 'package:flutter/material.dart';

import '../../models/theme.dart';
import '../../services/auth.dart';
import '../../services/card.dart';
import '../../services/database.dart';
import '../../services/theme.dart';
import '../../services/user_card.dart';
import '../cards/card_page.dart';
import '../edit theme/edit_theme.dart';

class ThemeButtonList extends StatefulWidget {
  final Future<List<SpacyTheme>> Function() getThemes;

  ThemeButtonList({required this.getThemes});

  @override
  _ThemeButtonListState createState() => _ThemeButtonListState();
}

class _ThemeButtonListState extends State<ThemeButtonList> {
  TextEditingController _textFieldController = TextEditingController();
  bool _showPopup = false;

  final UserCardService userCardService = UserCardService();
  final CardService cardService = CardService();
  final AuthService authService = AuthService();
  final ThemeService themeService = ThemeService();

  var search = '';

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _textFieldController,
                style: TextStyle(color: Colors.white70),
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    search = _textFieldController.text;
                  });
                  // Perform search/filtering based on the entered value
                },
              ),
            )),
        Expanded(
          child: FutureBuilder<List<SpacyTheme>>(
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
                    if (theme.name.toLowerCase().contains(search.toLowerCase()))
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        // Adjust the horizontal padding as needed
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CardPage(
                                    cards: theme.cards,
                                    userId:
                                        authService.getCurrentUser().toString(),
                                    theme: theme,
                                  ),
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
                                  theme.name,
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditThemeToggleView(
                                              theme: theme,
                                            ),
                                          ),
                                        );
                                        break;
                                      case 'share':
                                        _showSharePopup(
                                          theme.uid.toString(),
                                        );
                                        break;
                                      case 'archive':
                                        _showDeleteConfirmation(
                                            theme.uid.toString());
                                        break;
                                        // Perform archive action
                                        break;
                                    }
                                  },
                                  icon: Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  },
                );
              }

              return Center(
                child: Text(
                  'No themes found.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            },
          ),
        ),
      ],
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
                        var userId = await _userService.getUserIdByEmail(email);
                        await _userService.addToUserThemes(
                            userId.toString(), themeId);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      primary: Colors.white, // Set the button color to white
                      onPrimary: Colors.black,
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
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text(
              'If you delete the theme, you will lose all the statistics connected to it.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Call the deleteDocument function with the document ID
                themeService.deleteDocument(documentId);
                Navigator.pop(context); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
