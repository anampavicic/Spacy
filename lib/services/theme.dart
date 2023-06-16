import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spacy/models/card.dart';
import 'package:spacy/models/user_card.dart';
import 'package:spacy/screens/models/chart_data.dart';
import 'package:spacy/services/card.dart';
import 'package:spacy/services/database.dart';
import 'package:spacy/services/user_card.dart';

import '../models/theme.dart';
import '../screens/models/statistic_theme.dart';

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

  ///Get statistic theme
  Future<StatisticTheme> getStatisticTheme(
      String userId, String themeId) async {
    //get usrer card for user and theme
    List<UserCardData> userCardsForUser =
        await _userCardService.getUserCardsForThemeAndUser(themeId, userId);

    //get user cards for theme
    List<UserCardData> userCardsForEveryOne =
        await _userCardService.getUserCardsForTheme(themeId);

    //calculate percantageOfSolvedCardsByUser
    var sucesfullyComeptedByUser = 0;
    for (var userCard in userCardsForUser) {
      if (userCard.completed) {
        sucesfullyComeptedByUser++;
      }
    }
    double percantageOfSolvedCardsByUser =
        sucesfullyComeptedByUser / userCardsForUser.length;
    percantageOfSolvedCardsByUser *= 100;

    //calculate percantageOfSolvedCardsByEveryOne
    var sucesfullyComeptedEveryOne = 0;
    for (var userCard in userCardsForEveryOne) {
      if (userCard.completed) {
        sucesfullyComeptedEveryOne++;
      }
    }
    double percantageOfSolvedCardsByEveryOne =
        sucesfullyComeptedEveryOne / userCardsForEveryOne.length;
    percantageOfSolvedCardsByEveryOne *= 100;

    userCardsForUser.sort((a, b) => a.dataCompleted.compareTo(b.dataCompleted));
    userCardsForEveryOne
        .sort((a, b) => a.dataCompleted.compareTo(b.dataCompleted));

    //get graph data for user
    List<List<UserCardData>> graohData = [];
    DateTime firstDay = userCardsForUser[0].dataCompleted;
    //add one day
    firstDay.add(Duration(days: 1));

    List<UserCardData> forOneData = [];
    for (var usercard in userCardsForUser) {
      if (usercard.dataCompleted.isBefore(firstDay)) {
        forOneData.add(usercard);
      } else {
        graohData.add(forOneData);
        forOneData = [];
        forOneData.add(usercard);
        firstDay = usercard.dataCompleted.add(Duration(days: 1));
      }
    }
    graohData.add(forOneData);

    //get graph data for user
    List<List<UserCardData>> graohDataEveryone = [];
    DateTime firstDayEveryOne = userCardsForEveryOne[0].dataCompleted;
    //add one day
    firstDay.add(Duration(days: 1));

    List<UserCardData> forOneDataEveryone = [];
    for (var usercard in userCardsForEveryOne) {
      if (usercard.dataCompleted.isBefore(firstDay)) {
        forOneDataEveryone.add(usercard);
      } else {
        graohDataEveryone.add(forOneDataEveryone);
        forOneDataEveryone = [];
        forOneDataEveryone.add(usercard);
        firstDay = usercard.dataCompleted.add(Duration(days: 1));
      }
    }
    graohDataEveryone.add(forOneData);

    List<ChartData> chartDataUser = [];
    int i = 1;
    for (var list in graohData) {
      int sucess = 0;
      for (var userdcard in list) {
        if (userdcard.completed) {
          sucess++;
        }
      }
      double percant = (sucess / list.length) * 100;
      var data = ChartData(i, percant);
      chartDataUser.add(data);
      i++;
    }

    //get chart data for everyone
    List<ChartData> chartDataEveryOne = [];
    int j = 1;
    for (var list in graohDataEveryone) {
      int sucess = 0;
      for (var userdcard in list) {
        if (userdcard.completed) {
          sucess++;
        }
      }
      double percant = (sucess / list.length) * 100;
      var data = ChartData(j, percant);
      chartDataEveryOne.add(data);
      j++;
    }
    chartDataEveryOne.add(ChartData(0, 0));
    chartDataUser.add(ChartData(0, 0));

    List<FlashCard> cards = await _cardService.getFlashCardsIdForTheme(themeId);

    List<String> topThreeCards = [];
    List<String> worstThreeCards = [];
    for (int i = 0; i < cards.length && i < 3; i++) {
      topThreeCards.add(cards[i].question);
    }
    cards = cards.reversed.toList();
    for (int i = 0; i < cards.length && i < 3; i++) {
      worstThreeCards.add(cards[i].question);
    }
    print('graph chartDataUser');
    for (var user in chartDataUser) {
      print(user.x);
      print(user.y);
    }

    print('graph chartDataEveryOne');
    for (var user in chartDataEveryOne) {
      print(user.x);
      print(user.y);
    }
    return StatisticTheme(
        percantageOfSolvedCardsByUser,
        percantageOfSolvedCardsByEveryOne,
        chartDataUser,
        chartDataEveryOne,
        topThreeCards,
        worstThreeCards);
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
