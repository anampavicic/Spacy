import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spacy/models/card.dart';
import 'package:spacy/models/theme.dart';
import 'package:spacy/services/card.dart';
import 'package:spacy/services/theme.dart';

import '../models/user_card.dart';

class UserCard {
  final ThemeService _themeService = ThemeService();
  final CardService _cardService = CardService();
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

  Future<List<SpacyTheme>> getCardsForToday(String userId) async {
    List<Map<String, dynamic>> cards = [];
    final DateTime now = DateTime.now();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('user-card')
        .where('userId', isEqualTo: userId)
        .get();

    final List<Map<String, dynamic>> batch = querySnapshot.docs
        .map((DocumentSnapshot doc) => {
              'cardId': doc['cardId'],
              'themeId': doc['themeId'],
              'value': doc['value'],
              'userId': doc['userId'],
              'time_to_pass': doc['time_to_pass'],
              'completed': doc['completed'],
              'id': doc.id,
              // Include other attributes here
            })
        .where((element) => element['time_to_pass'] == null
            ? false
            : element['time_to_pass'].toDate().isBefore(now))
        .where((element) => element['completed'] != true)
        .toList();

    cards.addAll(batch);

    Map<String, List<Map<String, dynamic>>> sortedByThemeMap =
        Map<String, List<Map<String, dynamic>>>();

    for (int i = 0; i < batch.length; i++) {
      var themeId = batch[i]['themeId'];
      if (sortedByThemeMap.containsKey(themeId)) {
        sortedByThemeMap[themeId]?.add(batch[i]);
      } else {
        sortedByThemeMap[themeId] = [batch[i]];
      }
    }
    List<SpacyTheme> themes = [];

    for (var themeId in sortedByThemeMap.keys) {
      //var theme = await _themeService.getThemeById(themeId);
      SpacyTheme theme = SpacyTheme(
          deadline: DateTime.now(),
          name: 'ana',
          nextFibValue: 1,
          nextDate: DateTime.now());
      var deadline = theme?.deadline;
      if (deadline != null /*&& deadline.toDate().isBefore(DateTime.now())*/) {
        continue;
      }
      List<FlashCard> cards = [];
      var userCards = sortedByThemeMap[themeId]
          ?.map((e) => UserCardData(
              uid: e['id'],
              cardId: e['cardId'],
              value: e['value'],
              userId: e['userId'],
              themeId: e['themeId']))
          .toList();
      for (var userCard in userCards!) {
        var card = await _cardService.getCardByIdCard(userCard.cardId);
        cards.add(card!);
      }
      theme?.cards = cards;
      theme?.userCards = userCards.cast<UserCardData>();
      themes.add(theme!);
    }
    return themes;
  }
}
