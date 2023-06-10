import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spacy/services/card.dart';
import 'package:spacy/services/theme.dart';

class UserCard {
  final ThemeService _themeService = ThemeService();
  final CardService _cardService = CardService();
  final firestore = FirebaseFirestore.instance;
  final CollectionReference carduserCollection =
      FirebaseFirestore.instance.collection('user-card');

  //using
  Future<void> addUserCard(
      String themeId, String userId, String cardId, bool completed) async {
    print(themeId);
    final cardUserData = {
      'completed': completed,
      'themeId': themeId,
      'userId': userId,
      'cardId': cardId,
      'dataCompleted': Timestamp.fromDate(DateTime.now())
    };
    var id = await carduserCollection.doc().set(cardUserData);
  }
}
