import 'package:flutter/material.dart';
import 'package:spacy/services/auth.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spacy'),
      ),
      body: Container(
        child: Column(
          children: <Widget> [
            ElevatedButton(
              onPressed: () => _auth.signOut(),
              child: Text(
                  'sign out'
              ),
            ),
          ]
        )
      )
    );
  }
}
