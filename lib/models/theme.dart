import 'package:spacy/models/user_card.dart';

import 'card.dart';

class SpacyTheme {
  final String uid;
  final DateTime deadline;
  final String name;
  List<FlashCard>? cards;
  List<UserCard>? userCards;

  SpacyTheme(
      {required this.uid,
      required this.deadline,
      required this.name,
      this.cards,
      this.userCards});
}
