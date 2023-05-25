import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spacy/screens/utilities/convex_app_bar_one_button.dart';
import 'package:spacy/services/user_card.dart';

import '../utilities/background.dart';
import '../utilities/convex_app_bar.dart';

class CardPage extends StatefulWidget {
  final List<Map<String, dynamic>> cards;
  final List<Map<String, dynamic>> userCards;

  CardPage({required this.cards, required this.userCards});

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  bool _showAnswer = false;
  int _currentIndex = 0;

  final UserCard _userCard = UserCard();

  void noButtomInBottomBar() async {
    var userCard = widget.userCards[this._currentIndex];
    userCard['completed'] = false;
    await _userCard.updateUserCard(userCard);

    if (this._currentIndex == widget.cards.length - 1) {
      this._currentIndex = 0;
    } else {
      this._currentIndex++;
    }
    setState(() {
      this._showAnswer = false;
    });

    _questionController.text = widget.cards[_currentIndex]['question'];
    _answerController.text = widget.cards[_currentIndex]['answer'];
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
    var userCard = widget.userCards[this._currentIndex];
    var wasCompeted = userCard['completed'];
    userCard['completed'] = true;
    await _userCard.updateUserCard(userCard);

    //add a new user-card data
    int nextValue = wasCompeted == null
        ? fibonacciNext(userCard['value'])
        : userCard['value'];
    final userCardNew = {
      'time_to_pass':
          Timestamp.fromDate(DateTime.now().add(Duration(days: nextValue))),
      'value': nextValue,
      'completed': null,
      'themeId': userCard['themeId'],
      'userId': userCard['userId'],
      'cardId': userCard['cardId'],
    };
    //remove from the list that is iterate
    widget.cards.removeAt(_currentIndex);
    widget.userCards.removeAt(_currentIndex);

    //updathe the current card
    await _userCard.addUserCardNew(userCardNew);

    if (this._currentIndex == widget.cards.length - 1) {
      this._currentIndex = 0;
    } else {
      this._currentIndex++;
    }
    setState(() {
      this._showAnswer = false;
    });

    _questionController.text = widget.cards[_currentIndex]['question'];
    _answerController.text = widget.cards[_currentIndex]['answer'];
  }

  @override
  void initState() {
    super.initState();
    _questionController.text =
        widget.cards.length > 0 ? widget.cards[_currentIndex]['question'] : "";
    _answerController.text =
        widget.cards.length > 0 ? widget.cards[_currentIndex]['answer'] : "";
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
  if (number <= 0) {
    return 0;
  } else {
    int prev = 0;
    int current = 1;

    for (int i = 2; i <= number; i++) {
      int next = prev + current;
      prev = current;
      current = next;
    }

    return current;
  }
}
