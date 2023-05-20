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
        .where('theme', isEqualTo: themeId)
        .get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> card = doc.data();
      card['id'] = doc.id;
      cards.add(card);
    });

    return cards;
  }
}
