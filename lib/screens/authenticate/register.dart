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
    return  Scaffold(
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
    );;
  }
}
