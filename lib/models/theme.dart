import 'package:spacy/models/user_card.dart';

import 'card.dart';

class SpacyTheme {
  String? uid;
  DateTime? deadline;
  String name;
  int nextFibValue;
  DateTime nextDate;
  List<FlashCard> cards;
  List<UserCardData>? userCards;

  SpacyTheme(
      {required this.deadline,
      required this.name,
      required this.nextFibValue,
      required this.nextDate,
      this.userCards})
      : cards = [];
}
