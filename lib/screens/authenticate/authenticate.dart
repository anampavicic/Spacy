import 'package:flutter/material.dart';
import 'package:spacy/screens/authenticate/register.dart';
import 'package:spacy/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool isSignInPage = true;

  void toggleView() {
    setState(() {
      isSignInPage = !isSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isSignInPage) {
      return Container(
        child: SignIn(toggleView: toggleView),
      );
    } else {
      return Container(
        child: Register(toggleView: toggleView),
      );
    }
  }
}
