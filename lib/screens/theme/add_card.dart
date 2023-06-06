import 'package:flutter/material.dart';
import 'package:spacy/services/auth.dart';
import 'package:spacy/services/card.dart';

import '../../services/user_card.dart';
import '../utilities/background.dart';
import '../utilities/convex_app_bar.dart';
import 'congrast_screen.dart';

class AddCardPage extends StatefulWidget {
  final String themeId;
  final List<Map<String, dynamic>> cards;

  const AddCardPage({super.key, required this.themeId, required this.cards});

  @override
  _AddCardPageState createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  TextEditingController _questionController = TextEditingController();
  TextEditingController _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CardService _card = CardService();
  final UserCard _userCardService = UserCard();
  final AuthService _authService = AuthService();

  String question = "";
  String answer = "";
  int card_index = 0;

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
      Navigator.pop(this.context);
    } else {
      var card = widget.cards[this.card_index - 1];
      populateFields(card['question'], card['answer']);
      this.card_index--;
    }
  }

  void middleButtonInBottomBar() async {
    if (this._formKey.currentState!.validate()) {
      if (this.card_index < widget.cards.length) {
        //update the current card
        var current_card = widget.cards[this.card_index];
        final cardData = {
          'question': question,
          'answer': answer,
          'themeId': widget.themeId
        };
        await _card.updateCard(current_card['id'], cardData);

        Navigator.push(
            this.context,
            MaterialPageRoute(
              builder: (context) => CongratsScreen(
                  themeId: widget.themeId), // Navigate to AddThemePage
            ));
      } else {
        final cardData = {
          'question': question,
          'answer': answer,
          'themeId': widget.themeId
        };
        var cardId = await _card.addCard(cardData);
        widget.cards.add(cardData);
        await _userCardService.addUserCard(widget.themeId,
            _authService.getCurrentUser().toString(), cardId, false);
        Navigator.push(
            this.context,
            MaterialPageRoute(
              builder: (context) => CongratsScreen(
                themeId: widget.themeId,
              ), // Navigate to AddThemePage
            ));
      }
      card_index++;
    }
  }

  void nextButtomInBottomBar() async {
    if (_formKey.currentState!.validate()) {
      if (card_index < widget.cards.length) {
        //update the current card
        var current_card = widget.cards[card_index];
        final cardData = {
          'question': question,
          'answer': answer,
          'themeId': widget.themeId
        };
        await _card.updateCard(current_card['id'], cardData);

        if (card_index + 1 < widget.cards.length) {
          //populate the next card if exists else clear
          var card = widget.cards[card_index + 1];
          populateFields(card['question'], card[answer]);
        } else {
          clearFields();
        }
      } else {
        final cardData = {
          'question': question,
          'answer': answer,
          'themeId': widget.themeId
        };
        var cardId = await _card.addCard(cardData);
        await _userCardService.addUserCard(widget.themeId,
            _authService.getCurrentUser().toString(), cardId, false);
        widget.cards.add(cardData);
        print(widget.cards);
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
    if (widget.cards.isNotEmpty) {
      var cardData = widget.cards[0];
      _questionController.text = cardData['question'];
      _answerController.text = cardData['answer'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: GradientBoxDecoration.gradientBoxDecoration,
        child: Scaffold(
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
