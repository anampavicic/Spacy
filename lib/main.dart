import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spacy/screens/wrapper.dart';

Future<void> main() async {
  print ('running this app');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Wrapper(),
    );

  }
}

