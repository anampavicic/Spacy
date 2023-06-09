import 'package:flutter/material.dart';
import 'package:spacy/models/card.dart';
import 'package:spacy/services/auth.dart';
import 'package:spacy/services/card.dart';
import 'package:spacy/services/database.dart';

import '../../services/theme.dart';
import 'add_card_theme.dart';
import 'add_theme_details.dart';
import 'congrast_screen.dart';

class AddThemeToggleView extends StatefulWidget {
  const AddThemeToggleView({Key? key}) : super(key: key);

  @override
  State<AddThemeToggleView> createState() => _AddThemeToggleView();
}

class _AddThemeToggleView extends State<AddThemeToggleView> {
  final ThemeService _theme = ThemeService();
  final CardService _card = CardService();
  final AuthService _auth = AuthService();
  final UserService _user = UserService();
  bool isAddCard = false;

  String themeName = "";
  DateTime? deadline;
  List<FlashCard> cards = [];
  int currentIndex = 0;

  void toggleView() {
    setState(() {
      isAddCard = !isAddCard;
    });
    print("toggle view theme name");
    print(themeName);
  }

  void setThemeDetails(String name, DateTime? deadlineNew) {
    themeName = name;
    setState(() {
      themeName = name;
      deadline = deadlineNew;
    });
    print("theme detaails have been set");
  }

  List<FlashCard> getCards() {
    return cards;
  }

  void setCards(List<FlashCard> newCards) {
    cards = newCards;
  }

  int getCurrentIndex() {
    return currentIndex;
  }

  String getThemeName() {
    return themeName;
  }

  void addThemeWithCards() async {
    var id = await _theme.addThemeNew(themeName!, deadline, 1, DateTime.now());
    for (var card in cards) {
      card.themeId = id;
      await _card.addCardNew(card);
    }
    var userId = _auth.getCurrentUser();
    await _user.addToUserThemes(userId!, id);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CongratsScreen(themeId: id), // Navigate to AddThemePage
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (!isAddCard) {
      return Container(
        child: AddThemeDetailsPage(
          toggleView: toggleView,
          setThemeDetails: setThemeDetails,
          addThemeWithCards: addThemeWithCards,
          getThemeName: getThemeName,
          getCards: getCards,
        ),
      );
    } else {
      return Container(
        child: AddCardThemePage(
          getCurrentIndex: getCurrentIndex,
          setCards: setCards,
          addThemeWithCards: addThemeWithCards,
          toggleView: toggleView,
          getCards: getCards,
        ),
      );
    }
  }
}
