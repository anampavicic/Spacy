import 'package:flutter/material.dart';

class CardPage extends StatefulWidget {
  final List<String> cards;

  CardPage({required this.cards});

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  bool _showAnswer = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Question',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              if (widget.cards.isNotEmpty &&
                  _currentIndex < widget.cards.length)
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: _showAnswer
                        ? Text(
                            widget.cards[_currentIndex],
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                  ),
                )
              else
                Text(
                  'Congratulations! You have gone through all cards.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              SizedBox(height: 16.0),
              if (widget.cards.isNotEmpty &&
                  _currentIndex < widget.cards.length)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showAnswer = true;
                    });
                  },
                  child: Text('Show Answer'),
                ),
            ],
          ),
          bottomNavigationBar: null,
        ));
  }
}
