import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spacy/models/card.dart';
import 'package:spacy/services/card.dart';
import 'package:spacy/services/database.dart';

import '../models/theme.dart';
import '../models/user_card.dart';

class ThemeService {
  final UserService _userService = UserService();
  final CardService _cardService = CardService();

  final firestore = FirebaseFirestore.instance;
  final CollectionReference themeCollection =
      FirebaseFirestore.instance.collection('theme');

  Future<String> addThemeNew(String name, DateTime? deadline, int nextFibValue,
      DateTime nextDate) async {
    final themeData = {
      "name": name,
      "deadline": deadline == null ? null : Timestamp.fromDate(deadline),
      "nextFibValue": nextFibValue,
      "nextDate": Timestamp.fromDate(nextDate)
    };
    var id = await themeCollection.add(themeData).then((value) => value.id);
    return id;
  }

  Future<void> updateTheme(themeData, String themeId) async {
    final DocumentReference cardRef = await themeCollection.doc(themeId);

    await cardRef.update(themeData);
  }

  //using
  Future<List<SpacyTheme>> getThemeForTodayNew(String userId) async {
    final DateTime now = DateTime.now();
    List<SpacyTheme> themes = [];
    List<String> themeIds = await _userService.getUserThemeById(userId);
    for (var themeId in themeIds) {
      SpacyTheme? theme = await getThemeById(themeId);
      //tema ne smije biti null
      if (theme == null) {
        continue;
      } else {
        var deadline = theme.deadline;
        if (deadline != null && deadline.isBefore(now)) {
          continue;
        } else {
          if (theme.nextDate.isBefore(now)) {
            theme.uid = themeId;
            List<FlashCard> cards =
                await _cardService.getFlashCardsIdForTheme(themeId);
            theme.cards = cards;
            themes.add(theme);
          }
        }
      }
    }
    return themes;
  }

  //using
  Future<List<SpacyTheme>> getThemeForActiveNew(String userId) async {
    final DateTime now = DateTime.now();
    List<SpacyTheme> themes = [];
    List<String> themeIds = await _userService.getUserThemeById(userId);
    for (var themeId in themeIds) {
      SpacyTheme? theme = await getThemeById(themeId);
      //tema ne smije biti null
      if (theme == null) {
        continue;
      } else {
        var deadline = theme.deadline;
        if (deadline != null && deadline.isBefore(now)) {
          continue;
        } else {
          theme.uid = themeId;
          List<FlashCard> cards =
              await _cardService.getFlashCardsIdForTheme(themeId);
          print("active cards lenght");
          print(cards.length);
          theme.cards = cards;
          themes.add(theme);
        }
      }
    }
    return themes;
  }

  ///GetThemesForAll
  Future<List<SpacyTheme>> getThemeForAllNew(String userId) async {
    final DateTime now = DateTime.now();
    List<SpacyTheme> themes = [];
    List<String> themeIds = await _userService.getUserThemeById(userId);
    for (var themeId in themeIds) {
      SpacyTheme? theme = await getThemeById(themeId);
      //tema ne smije biti null
      if (theme == null) {
        continue;
      } else {
        theme.uid = themeId;
        List<FlashCard> cards =
            await _cardService.getFlashCardsIdForTheme(themeId);
        theme.cards = cards;
        themes.add(theme);
      }
    }
    return themes;
  }

  Future<String> addTheme(themeData) async {
    var id = await themeCollection.add(themeData).then((value) => value.id);
    return id;
  }

  Future<SpacyTheme?> getThemeById(String themeId) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('theme').doc(themeId).get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>?;
      DateTime? deadline = data!['deadline'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(data!['deadline']);
      return SpacyTheme(
          deadline: deadline,
          name: data['name'],
          nextFibValue: data['nextFibValue'],
          nextDate: data['nextDate'].toDate());
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getThemesByIdsForActive2(
      List<String> listOfIds) async {
    print('Active');
    final DateTime now = DateTime.now();
    final Timestamp today =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    final QuerySnapshot snapshot = await firestore
        .collection('theme')
        .where(FieldPath.documentId, whereIn: listOfIds)
        .get();

    final List<Map<String, dynamic>> themes = snapshot.docs
        .where((element) => element['deadline'] == null
            ? true
            : element['deadline'].toDate().isAfter(now))
        .map((DocumentSnapshot doc) => {
              'name': doc['name'],
              'id': doc.id,
            })
        .toList();

    return themes;
  }

  Future<List<Map<String, dynamic>>> getThemesByIdsForActive(
      List<String> listOfIds) async {
    print('All');
    final DateTime now = DateTime.now();
    final Timestamp today =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    final List<Map<String, dynamic>> themes = [];

    final batchSize = 10; // Maximum number of IDs per batch
    final totalBatches = (listOfIds.length / batchSize).ceil();

    for (var i = 0; i < totalBatches; i++) {
      final start = i * batchSize;
      final end = (i + 1) * batchSize;

      final List<String> batchIds = listOfIds.sublist(
          start, end > listOfIds.length ? listOfIds.length : end);

      final QuerySnapshot snapshot = await firestore
          .collection('theme')
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      final List<Map<String, dynamic>> batchThemes = snapshot.docs
          .map((DocumentSnapshot doc) => {
                'name': doc['name'],
                'id': doc.id,
                // Include other attributes here
              })
          .where((element) => element['deadline'] == null
              ? true
              : element['deadline'].toDate().isAfter(now))
          .toList();

      themes.addAll(batchThemes);
    }

    return themes;
  }

  Future<List<Map<String, dynamic>>> getThemesByIdsForAll(
      List<String> listOfIds) async {
    print('All');
    final DateTime now = DateTime.now();
    final Timestamp today =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    final List<Map<String, dynamic>> themes = [];

    final batchSize = 10; // Maximum number of IDs per batch
    final totalBatches = (listOfIds.length / batchSize).ceil();

    for (var i = 0; i < totalBatches; i++) {
      final start = i * batchSize;
      final end = (i + 1) * batchSize;

      final List<String> batchIds = listOfIds.sublist(
          start, end > listOfIds.length ? listOfIds.length : end);

      final QuerySnapshot snapshot = await firestore
          .collection('theme')
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      final List<Map<String, dynamic>> batchThemes = snapshot.docs
          .map((DocumentSnapshot doc) => {
                'name': doc['name'],
                'id': doc.id,
                // Include other attributes here
              })
          .toList();

      themes.addAll(batchThemes);
    }

    return themes;
  }

  Future<List<Map<String, dynamic>>> getThemesByIdsForToday(
      List<String> listOfIds) async {
    print('All');
    final DateTime now = DateTime.now();
    final Timestamp today =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    final List<Map<String, dynamic>> themes = [];

    final batchSize = 10; // Maximum number of IDs per batch
    final totalBatches = (listOfIds.length / batchSize).ceil();

    for (var i = 0; i < totalBatches; i++) {
      final start = i * batchSize;
      final end = (i + 1) * batchSize;

      final List<String> batchIds = listOfIds.sublist(
          start, end > listOfIds.length ? listOfIds.length : end);

      final QuerySnapshot snapshot = await firestore
          .collection('theme')
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      final List<Map<String, dynamic>> batchThemes = snapshot.docs
          .map((DocumentSnapshot doc) => {
                'name': doc['name'],
                'id': doc.id,
                // Include other attributes here
              })
          .where((element) => element['firstDayToRepeat'] == null
              ? true
              : element['firstDayToRepeat'].toDate().isBefore(now))
          .toList();

      themes.addAll(batchThemes);
    }

    return themes;
  }

  Future<List<SpacyTheme>> getThemesForActive(String userId) async {
    List<SpacyTheme> themes = [];
    List<String> themeIds = await _userService.getUserThemeById(userId);
    final DateTime now = DateTime.now();

    for (var themeId in themeIds) {
      var theme = await getThemeById(themeId);
      /*bool? archive = theme?.archive == null ? false : theme?.archive;
      if (archive == true) {
        continue;
      }*/
      var deadline = theme?.deadline;
      if (deadline != null && deadline.isBefore(DateTime.now())) {
        continue;
      }
      var cards = await _cardService.getFlashCardsIdForTheme(themeId);
      List<UserCardData> userCards = [];
      for (var card in cards) {}
    }
    return themes;
  }
}
