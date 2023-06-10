import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spacy/models/card.dart';
import 'package:spacy/models/theme.dart';
import 'package:spacy/screens/utilities/convex_app_bar_one_button.dart';
import 'package:spacy/services/theme.dart';
import 'package:spacy/services/user_card.dart';

import '../utilities/background.dart';
import '../utilities/convex_app_bar.dart';

class CardPage extends StatefulWidget {
  final List<FlashCard> cards;
  final String userId;
  final SpacyTheme theme;

  CardPage({required this.cards, required this.userId, required this.theme});

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  final ThemeService _themeService = ThemeService();
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  bool _showAnswer = false;
  int _currentIndex = 0;

  final UserCardService _userCard = UserCardService();

  void noButtomInBottomBar() async {
    await _userCard.addUserCard(widget.cards[_currentIndex].themeId.toString(),
        widget.userId, widget.cards[_currentIndex].uid.toString(), false);

    if (this._currentIndex == widget.cards.length - 1) {
      this._currentIndex = 0;
    } else {
      this._currentIndex++;
    }
    setState(() {
      this._showAnswer = false;
    });

    _questionController.text = widget.cards[_currentIndex].question;
    _answerController.text = widget.cards[_currentIndex].answer;
  }

  void middleButtonInBottomBar() {
    setState(() {
      this._showAnswer = true;
    });
  }

  void middleButton() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void yesButtonInBottomBar() async {
    //update the user_card
    await _userCard.addUserCard(widget.theme.uid.toString(), widget.userId,
        widget.cards[_currentIndex].uid.toString(), true);

    //remove from the list that is iterate
    widget.cards.removeAt(_currentIndex);

    if (widget.cards.length == 0) {
      updateTheme();
    }

    if (this._currentIndex == widget.cards.length - 1) {
      this._currentIndex = 0;
    } else {
      this._currentIndex++;
    }
    setState(() {
      this._showAnswer = false;
    });

    _questionController.text = widget.cards[_currentIndex].question;
    _answerController.text = widget.cards[_currentIndex].question;
  }

  void updateTheme() async {
    var nextFibb = fibonacciNext(widget.theme.nextFibValue);
    final data = {
      "nextDate":
          Timestamp.fromDate(DateTime.now().add(Duration(days: nextFibb))),
      "nextFibValue": nextFibb
    };
    await _themeService.updateTheme(data, widget.theme.uid.toString());
  }

  @override
  void initState() {
    super.initState();
    _questionController.text =
        widget.cards.length > 0 ? widget.cards[_currentIndex].question : "";
    _answerController.text =
        widget.cards.length > 0 ? widget.cards[_currentIndex].answer : "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GradientBoxDecoration.gradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              if (widget.cards.isNotEmpty &&
                  _currentIndex < widget.cards.length)
                TextField(
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                    borderSide: BorderSide.none, // Remove the bottom border
                  )),
                  controller: _questionController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
              SizedBox(height: 20.0),
              if (_showAnswer)
                TextField(
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                    borderSide: BorderSide.none, // Remove the bottom border
                  )),
                  textAlign: TextAlign.center,
                  controller: _answerController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (widget.cards.isEmpty || _currentIndex >= widget.cards.length)
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    children: [
                      TextSpan(
                        text: 'Congratulations!\n',
                        style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      WidgetSpan(
                        child: SizedBox(
                            height: 30.0), // Add extra space using SizedBox
                      ),
                      TextSpan(text: 'You have gone through all cards.'),
                    ],
                  ),
                ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
        bottomNavigationBar:
            widget.cards.isNotEmpty && _currentIndex < widget.cards.length
                ? CustomConvexBottomAppBar(
                    leftIcon: Icons.thumb_down,
                    middleIcon: Icons.question_mark_rounded,
                    rightIcon: Icons.thumb_up,
                    leftButtonPressed: noButtomInBottomBar,
                    middleButtonPressed: middleButtonInBottomBar,
                    rightButtonPressed: yesButtonInBottomBar,
                  )
                : CustomConvexBottomAppBarOneButton(
                    middleIcon: Icons.check,
                    middleButtonPressed: middleButton,
                  ),
      ),
    );
  }
}

int fibonacciNext(int number) {
  if (number >= 55) {
    return 55;
  }
  if (number <= 0) {
    return 0;
  } else {
    int prev = 1;
    int current = 2;

    for (int i = 2; i <= number; i++) {
      int next = prev + current;
      prev = current;
      current = next;
    }
    return current;
  }
}
