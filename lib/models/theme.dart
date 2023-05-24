import 'package:spacy/models/user_card.dart';

import 'card.dart';

class SpacyTheme {
  final String uid;
  final DateTime deadline;
  final String name;
  final List<FlashCard> cards;
  final List<UserCard> userCards;

  SpacyTheme(
      {required this.uid,
      required this.deadline,
      required this.name,
      required this.cards,
      required this.userCards});
}
