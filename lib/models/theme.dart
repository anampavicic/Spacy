import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spacy/models/user_card.dart';

import 'card.dart';

class SpacyTheme {
  final String uid;
  final Timestamp? deadline;
  final String name;
  List<FlashCard>? cards;
  List<UserCardData>? userCards;

  SpacyTheme(
      {required this.uid,
      required this.deadline,
      required this.name,
      this.cards,
      this.userCards});
}
