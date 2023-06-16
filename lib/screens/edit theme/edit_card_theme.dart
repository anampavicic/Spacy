import 'package:flutter/material.dart';
import 'package:spacy/services/auth.dart';
import 'package:spacy/services/card.dart';

import '../../models/card.dart';
import '../../services/user_card.dart';
import '../utilities/background.dart';
import '../utilities/convex_app_bar.dart';

class EditCardThemePage extends StatefulWidget {
  final Function getCurrentIndex;
  final Function setCards;
  final Function editThemeWithCards;
  final Function toggleView;
  final Function getCards;

  const EditCardThemePage({
    super.key,
    required this.getCurrentIndex,
    required this.setCards,
    required this.editThemeWithCards,
    required this.toggleView,
    required this.getCards,
  });

  @override
  _EditCardThemePageState createState() => _EditCardThemePageState();
}

class _EditCardThemePageState extends State<EditCardThemePage> {
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CardService _card = CardService();
  final UserCardService _userCardService = UserCardService();
  final AuthService _authService = AuthService();

  String question = "";
  String answer = "";
  int card_index = 0;
  List<FlashCard> cards = [];

  void clearFields() {
    _questionController.clear();
    _answerController.clear();
  }

  void populateFields(String questionNew, String answerNew) {
    _questionController.text = questionNew;
    _answerController.text = answerNew;
    question = questionNew;
    answer = answerNew;
  }

  void backButtonInBottomBar() async {
    if (this.card_index == 0) {
      if (this._formKey.currentState!.validate()) {
        //ako već od prije ne postoji kartica, znaci prva je
        if (cards.isNotEmpty) {
          cards[card_index].question = question;
          cards[card_index].answer = answer;
        } else {
          FlashCard card = FlashCard(question: question, answer: answer);
          cards.add(card);
        }
        widget.setCards(cards);
        widget.toggleView();
      }
    } else {
      cards[card_index].question = question;
      cards[card_index].answer = answer;
      widget.setCards(cards);
      var card = cards[this.card_index - 1];
      populateFields(card.question, card.answer);
      this.card_index--;
    }
  }

  void middleButtonInBottomBar() async {
    if (this._formKey.currentState!.validate()) {
      if (this.card_index < cards.length) {
        //update the current card
        var currentCard = cards[this.card_index];
        currentCard.question = question;
        currentCard.answer = answer;

        widget.setCards(cards);
        widget.editThemeWithCards();
      } else {
        FlashCard card = FlashCard(question: question, answer: answer);
        cards.add(card);
        widget.setCards(cards);
        widget.editThemeWithCards();
      }
      card_index++;
    }
  }

  void nextButtomInBottomBar() async {
    if (_formKey.currentState!.validate()) {
      if (card_index < cards.length) {
        //update the current card
        var current_card = cards[card_index];
        current_card.question = question;
        current_card.answer = answer;

        if (card_index + 1 < cards.length) {
          //populate the next card if exists else clear
          var card = cards[card_index + 1];
          populateFields(card.question, card.answer);
        } else {
          clearFields();
        }
      } else {
        FlashCard card = FlashCard(question: question, answer: answer);
        cards.add(card);
        clearFields();
      }
      card_index++;
    }
  }

  void deleteCard() {
    //ako smo došli do prve čiste stranice
    if (card_index >= cards.length) {
      if (card_index <= 0) {
        widget.toggleView();
      } else {
        setState(() {
          card_index--;
        });
        var cardData = cards[card_index];
        populateFields(cardData.question, cardData.answer);
      }
    } else {
      cards.removeAt(card_index);
      if (card_index >= cards.length - 1) {
        card_index--;
      }
      if (cards.isNotEmpty) {
        var cardData = cards[card_index];
        populateFields(cardData.question, cardData.answer);
      } else {
        widget.toggleView();
      }
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cards = widget.getCards();
    if (cards.isNotEmpty) {
      var cardData = cards[0];
      _questionController.text = cardData.question;
      _answerController.text = cardData.answer;
      question = cardData.question;
      answer = cardData.answer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: GradientBoxDecoration.gradientBoxDecoration,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Text(
                      'Edit a card',
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
                        controller: _questionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Question',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
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
                            question = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Question cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: _answerController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value) {
                          setState(() {
                            answer = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Answer cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: deleteCard,
                        style: ElevatedButton.styleFrom(
                          primary:
                              Colors.white70, // Set background color to gray
                          onPrimary: Colors.red[900], // Set text color to red
                          minimumSize: Size(double.infinity,
                              50), // Set width to stretch across the screen and height to 50
                        ),
                        child: Text(
                          'Delete this card',
                          style: TextStyle(
                            color: Colors.red[900], // Set text color to red
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
        bottomNavigationBar: CustomConvexBottomAppBar(
          leftIcon: Icons.arrow_back_ios_new,
          middleIcon: Icons.check,
          rightIcon: Icons.arrow_forward_ios,
          leftButtonPressed: backButtonInBottomBar,
          middleButtonPressed: middleButtonInBottomBar,
          rightButtonPressed: nextButtomInBottomBar,
        ),
      ),
    );
  }
}
