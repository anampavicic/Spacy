import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spacy/models/card.dart';
import 'package:spacy/models/user_card.dart';
import 'package:spacy/services/card.dart';
import 'package:spacy/services/database.dart';
import 'package:spacy/services/user_card.dart';

import '../models/theme.dart';

class ThemeService {
  final UserService _userService = UserService();
  final CardService _cardService = CardService();
  final UserCardService _userCardService = UserCardService();

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

  ///update theme
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

  ///get theme for active
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

  ///delete theme
  Future<void> deleteDocument(String documentId) async {
    try {
      await themeCollection.doc(documentId).delete();
      //dellete all the cards connected to it
      //delete the theme from this user
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  ///Get theme for statistic
  Future<List<SpacyTheme>> getThemesForStatistic(String userId) async {
    final DateTime now = DateTime.now();
    List<SpacyTheme> themes = [];
    List<String> themeIds = await _userService.getUserThemeById(userId);
    for (var themeId in themeIds) {
      SpacyTheme? theme = await getThemeById(themeId);
      //tema ne smije biti null
      if (theme == null) {
        continue;
      }
      //set theme ttributes
      theme.uid = themeId;
      List<FlashCard> cards =
          await _cardService.getFlashCardsIdForTheme(themeId);

      List<UserCardData> userCards =
          await _userCardService.getUserCardsForThemeAndUser(themeId, userId);
      int succesfulyCompleted = 0;
      for (var userCard in userCards) {
        if (userCard.completed) {
          succesfulyCompleted++;
        }
      }
      theme.percentOfSolvedCardsForUser =
          succesfulyCompleted / userCards.length;
      theme.cards = cards;
      themes.add(theme);
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
      DateTime? deadline =
          data!['deadline'] == null ? null : data!['deadline'].toDate();
      return SpacyTheme(
          deadline: deadline,
          name: data['name'],
          nextFibValue: data['nextFibValue'],
          nextDate: data['nextDate'].toDate());
    }
    return null;
  }
}
