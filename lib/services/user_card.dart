import 'package:cloud_firestore/cloud_firestore.dart';

class UserCard {
  final firestore = FirebaseFirestore.instance;
  final CollectionReference carduserCollection =
      FirebaseFirestore.instance.collection('user-card');

  Future addUserCard(String themeId, String userId, String cardId) async {
    print('we are adding user card');
    final cardUserData = {
      'time_to_pass': Timestamp.fromDate(DateTime.now()),
      'value': 1,
      'completed': null,
      'themeId': themeId,
      'userId': userId,
      'cardId': cardId,
    };
    var id = await carduserCollection.doc().set(cardUserData);
  }

  Future addUserCardNew(userCardData) async {
    await carduserCollection.doc().set(userCardData);
  }

  Future<void> updateUserCard(cardData) async {
    final data = {'completed': cardData['completed']};
    final DocumentReference cardRef =
        await carduserCollection.doc(cardData['id']);

    await cardRef.update(data);
  }

  Future<List<Map<String, dynamic>>> getCardsForThemeAndUserToday(
      String userId, String themeId) async {
    List<Map<String, dynamic>> cards = [];
    final DateTime now = DateTime.now();
    final Timestamp today =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    print('themeId $themeId');
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('user-card')
        .where('themeId', isEqualTo: themeId)
        .where('userId', isEqualTo: userId)
        .where('completed', isEqualTo: null)
        .get();

    final List<Map<String, dynamic>> batch = querySnapshot.docs
        .map((DocumentSnapshot doc) => {
              'cardId': doc['cardId'],
              'themeId': doc['themeId'],
              'value': doc['value'],
              'userId': doc['userId'],
              'id': doc.id,
              // Include other attributes here
            })
        .where((element) => element['time_to_pass'] == null
            ? true
            : element['firstDayToRepeat'].toDate().isBefore(now))
        .toList();

    cards.addAll(batch);

    return cards;
  }
}
