import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spacy/services/auth.dart';

class Register extends StatefulWidget {
  //  const Register({Key? key}) : super(key: key);
  final Function toggleView;
  Register({required this.toggleView});
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String password = '';
  String email = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    /*return  Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Spacy',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value == null || value.isEmpty ? 'Name cannot be empty' : null,
                  onChanged: (value)  {
                    setState(() {
                      name = value;
                    });
                  }
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                    }
                    return null;
                  },
                  onChanged: (value)  {
                    setState(() {
                      email = value;
                    });
                  }
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) => value == null || value.length < 6 ? 'Enter longer password' : null,
                  onChanged: (value)  {
                    setState(() {
                      password = value;
                    });
                  }
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('Register'),
                  onPressed: () async {
                    if (_formKey .currentState != null && _formKey .currentState!.validate()){
                      dynamic result = await _auth.registerUserWithEmailAndPassword(email, password);
                      if (result != null){
                        print('user is succesfuly registered');
                      }
                      else {
                        setState(() {
                          error = 'regstration is not sucesfuly';
                        });
                      }
                    }
                    //_auth.regi
                  },
                ),
                const SizedBox (
                  height: 10,
                ),
                Text(error),
                const SizedBox(
                  height: 20,
                ),
                Text('Already have an account?'),
                ElevatedButton(
                  child: Text('Log in'),
                  onPressed: () async {
                    widget.toggleView();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );;*/
    return Container(
      decoration: BoxDecoration(
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Text(
                    'Spacy',
                    style: TextStyle(
                      fontSize: 70.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 4.0,
                    left: 4.0,
                    child: Text(
                      'Spacy',
                      style: TextStyle(
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (val) =>
                        val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Repeat password',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (val)  {
                        if (val != password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },//val != password ? 'Passwords do not match' : null,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Color(0xFF0F2027),
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                      ),
                      child: Text('Register', style: TextStyle(fontSize: 16.0)),
                      onPressed: () async {
                        if (_formKey.currentState != null && _formKey.currentState!.validate()){
                          dynamic result = await _auth.registerUserWithEmailAndPassword(email, password);
                          if (result != null){
                            print('user is succesfuly registered');
                          }
                          else {
                            setState(() {
                              error = 'regstration is not sucesfuly';
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14.0,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'LogIn',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      widget.toggleView();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
