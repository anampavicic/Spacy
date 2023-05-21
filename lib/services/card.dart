import 'package:cloud_firestore/cloud_firestore.dart';

class CardService {
  final firestore = FirebaseFirestore.instance;
  final CollectionReference cardsCollection =
      FirebaseFirestore.instance.collection('cards');

  Future<String> addCard(cardData) async {
    var id = await cardsCollection.add(cardData).then((value) => value.id);
    return id;
  }

  Future<void> updateCard(String cardId, cardData) async {
    final DocumentReference cardRef = await cardsCollection.doc(cardId);

    await cardRef.update(cardData);
  }

  Future<Map<String, dynamic>> getCardById(String cardId) async {
    final DocumentSnapshot snapshot = await cardsCollection.doc(cardId).get();

    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    }

    return {};
  }

  Future<List<String>> getCardsIdForTheme(String themeId) async {
    List<String> cardIds = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('cards')
        .where('theme', isEqualTo: themeId)
        .get();

    querySnapshot.docs.forEach((doc) {
      cardIds.add(doc.id);
    });

    return cardIds;
  }

  Future<List<Map<String, dynamic>>> getCardsForTheme(String themeId) async {
    List<Map<String, dynamic>> cards = [];

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('cards')
        .where('themeId', isEqualTo: themeId)
        .get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> card = doc.data();
      card['id'] = doc.id;
      cards.add(card);
    });

    return cards;
  }

  Future<List<Map<String, dynamic>>> getCardsForToday(
      List<String> cardIds, String themeId) async {
    final List<Map<String, dynamic>> cards = [];

    final batchSize = 10; // Maximum number of IDs per batch
    final totalBatches = (cardIds.length / batchSize).ceil();

    for (var i = 0; i < totalBatches; i++) {
      final start = i * batchSize;
      final end = (i + 1) * batchSize;

      final List<String> batchIds =
          cardIds.sublist(start, end > cardIds.length ? cardIds.length : end);

      final QuerySnapshot snapshot = await firestore
          .collection('cards')
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      print(snapshot.docs.toList());
      final List<Map<String, dynamic>> batchThemes = snapshot.docs
          .map((DocumentSnapshot doc) => {
                'question': doc['question'],
                'answer': doc['answer'],
                'id': doc.id,
                // Include other attributes here
              })
          .toList();

      cards.addAll(batchThemes);
    }
    return cards;
  }
}
