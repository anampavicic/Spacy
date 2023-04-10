import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {

  //_name mean private attribute
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseApp _app = Firebase.initializeApp();

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      //_app = await Firebase.initializeApp();
      //_auth = FirebaseAuth.instance;

      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e){
        print(e.toString());
      return null;
    }
  }
  //register withe email and password
  Future registerUserWithEmailAndPassword (String email, String password) async {
    try{
      //_app = await Firebase.initializeApp();
      //_auth = FirebaseAuth.instance;
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }catch (e){
      print(e);
      return null;
    }
  }


  //sign out method

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}