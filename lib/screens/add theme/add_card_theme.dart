import 'package:flutter/material.dart';
import 'package:spacy/services/auth.dart';
import 'package:spacy/services/card.dart';

import '../../models/card.dart';
import '../../services/user_card.dart';
import '../utilities/background.dart';
import '../utilities/convex_app_bar.dart';

class AddCardThemePage extends StatefulWidget {
  final Function getCurrentIndex;
  final Function setCards;
  final Function addThemeWithCards;
  final Function toggleView;
  final Function getCards;

  const AddCardThemePage({
    super.key,
    required this.getCurrentIndex,
    required this.setCards,
    required this.addThemeWithCards,
    required this.toggleView,
    required this.getCards,
  });

  @override
  _AddCardThemePageState createState() => _AddCardThemePageState();
}

class _AddCardThemePageState extends State<AddCardThemePage> {
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

  void populateFields(String question, String answer) {
    _questionController.text = question;
    _answerController.text = answer;
  }

  void backButtonInBottomBar() async {
    if (this.card_index == 0) {
      if (this._formKey.currentState!.validate()) {
        FlashCard card = FlashCard(question: question, answer: answer);
        cards.add(card);
        widget.setCards(cards);
        print(cards.length);
        widget.toggleView();
      }
    } else {
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
        widget.addThemeWithCards();
      } else {
        FlashCard card = FlashCard(question: question, answer: answer);
        cards.add(card);
        widget.setCards(cards);
        widget.addThemeWithCards();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: GradientBoxDecoration.gradientBoxDecoration,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
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
                          'Add a card',
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
                              hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.5)),
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
                          const SizedBox(height: 20.0)
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
            )));
  }
}
