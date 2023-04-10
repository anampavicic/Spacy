import 'package:flutter/material.dart';
import 'package:spacy/screens/authenticate/authenticate.dart';
import 'package:spacy/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spacy/services/auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().user,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading spinner while waiting for the user's auth state to resolve
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData) {
            // The user is logged in, so show the home screen
            return Home();
          } else {
            // The user is not logged in, so show the login screen
            return MaterialApp(
              home: Authenticate(),
            );
          }
        }
      },
    );
  }
}


/*class Wrapper extends StatelessWidget {
  //const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    //return eather home or authenitcte widget
    print('bla');
    if (user == null){
      print('we will authenticate');
      return Authenticate();
    } else {
      print('we will retun home');
      return Home();
    }
  }
}*/
