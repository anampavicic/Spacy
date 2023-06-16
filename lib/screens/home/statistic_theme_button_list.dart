import 'package:flutter/material.dart';
import 'package:spacy/models/theme.dart';
import 'package:spacy/services/auth.dart';
import 'package:spacy/services/card.dart';
import 'package:spacy/services/theme.dart';
import 'package:spacy/services/user_card.dart';

import '../statistic/statistic.dart';

class StatisticThemeButtonList extends StatefulWidget {
  final Future<List<SpacyTheme>> Function() getThemes;

  StatisticThemeButtonList({required this.getThemes});

  @override
  _StatisticThemeButtonListState createState() =>
      _StatisticThemeButtonListState();
}

class _StatisticThemeButtonListState extends State<StatisticThemeButtonList> {
  TextEditingController _textFieldController = TextEditingController();
  bool _showPopup = false;

  final UserCardService userCardService = UserCardService();
  final CardService cardService = CardService();
  final AuthService authService = AuthService();
  final ThemeService themeService = ThemeService();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SpacyTheme>>(
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
                      onPressed: () async {
                        var statisticTheme =
                            await themeService.getStatisticTheme(
                                authService.getCurrentUser().toString(),
                                theme.uid.toString());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StatisticPage(
                              statisticTheme: statisticTheme,
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
}
