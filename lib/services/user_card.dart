import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_card.dart';

class UserCardService {
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

  ///get user cards for the theme and User
  Future<List<UserCardData>> getUserCardsForThemeAndUser(
      String themeId, String userId) async {
    List<UserCardData> cards = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('user-card')
        .where('themeId', isEqualTo: themeId)
        .where('userId', isEqualTo: userId)
        .get();

    querySnapshot.docs.forEach((doc) {
      cards.add(UserCardData(
          uid: doc.id,
          cardId: doc['cardId'],
          userId: doc['userId'],
          themeId: doc['themeId'],
          completed: doc['completed'],
          dataCompleted: doc['dataCompleted'].toDate()));
    });
    return cards;
  }
}
