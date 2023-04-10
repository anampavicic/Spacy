import 'package:flutter/material.dart';
import 'package:spacy/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({required this.toggleView});
  //const SignIn({Key? key}) : super(key: key);


  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();


  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text ('sign in into spacy'),
        actions: <Widget>[
          IconButton(
            onPressed: (){
              widget.toggleView();
            },
            icon: Icon(Icons.person),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          child: Column(
            children: <Widget> [
              SizedBox(height: 20.0,),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });

                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                obscureText: true,
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async{
                  _auth.signInWithEmailAndPassword(email, password);
                  print(email);
                  print(password);
                },
              ),
            ],
          ),
        )
      ),
    );
  }
}
