import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spacy/models/card.dart';
import 'package:spacy/models/theme.dart';
import 'package:spacy/services/auth.dart';
import 'package:spacy/services/card.dart';
import 'package:spacy/services/database.dart';

import '../../services/theme.dart';
import 'edit_card_theme.dart';
import 'edit_theme_details.dart';

class EditThemeToggleView extends StatefulWidget {
  final SpacyTheme theme;
  const EditThemeToggleView({Key? key, required this.theme}) : super(key: key);

  @override
  State<EditThemeToggleView> createState() => _EditThemeToggleView();
}

class _EditThemeToggleView extends State<EditThemeToggleView> {
  final ThemeService _theme = ThemeService();
  final CardService _card = CardService();
  final AuthService _auth = AuthService();
  final UserService _user = UserService();
  bool isEditCard = false;

  String themeName = "";
  DateTime? deadline;
  List<FlashCard> cards = [];
  int currentIndex = 0;

  void toggleView() {
    setState(() {
      isEditCard = !isEditCard;
    });
  }

  void updateThemeDetails(String name, DateTime? deadlineNew) {
    //themeName = name;
    setState(() {
      themeName = name;
      deadline = deadlineNew;
    });
    widget.theme.name = name;
    widget.theme.deadline = deadlineNew;
  }

  List<FlashCard> getCards() {
    return cards;
    //return widget.theme.cards;
  }

  void setCards(List<FlashCard> newCards) {
    setState(() {
      cards = newCards;
    });
    widget.theme.cards = newCards;
  }

  int getCurrentIndex() {
    return currentIndex;
  }

  String getThemeName() {
    return widget.theme.name;
  }

  void editThemeWithCards() async {
    DateTime? deadline =
        widget.theme.deadline == null ? null : widget.theme.deadline;
    final themeData = {
      "name": widget.theme.name,
      "deadline": deadline == null ? null : Timestamp.fromDate(deadline),
    };
    await _theme.updateTheme(themeData, widget.theme.uid.toString());
    for (var card in cards) {
      if (card.uid != null) {
        final cardData = {"question": card.question, "answer": card.answer};
        await _card.updateCard(card.uid.toString(), cardData);
      } else {
        card.themeId = widget.theme.uid;
        await _card.addCardNew(card);
      }
    }
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  void initState() {
    super.initState();
    cards = widget.theme.cards;
  }

  @override
  Widget build(BuildContext context) {
    if (!isEditCard) {
      return Container(
        child: EditThemeDetailsPage(
          toggleView: toggleView,
          setThemeDetails: updateThemeDetails,
          editThemeWithCards: editThemeWithCards,
          getThemeName: getThemeName,
          getCards: getCards,
        ),
      );
    } else {
      return Container(
        child: EditCardThemePage(
          getCurrentIndex: getCurrentIndex,
          setCards: setCards,
          editThemeWithCards: editThemeWithCards,
          toggleView: toggleView,
          getCards: getCards,
        ),
      );
    }
  }
}
