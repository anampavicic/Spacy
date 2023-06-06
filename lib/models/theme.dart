import 'package:spacy/models/user_card.dart';

import 'card.dart';

class SpacyTheme {
  String? uid;
  final DateTime? deadline;
  final String name;
  final int nextFibValue;
  final DateTime nextDate;
  List<FlashCard>? cards;
  List<UserCardData>? userCards;

  SpacyTheme(
      {required this.deadline,
      required this.name,
      required this.nextFibValue,
      required this.nextDate,
      this.cards,
      this.userCards});
}
