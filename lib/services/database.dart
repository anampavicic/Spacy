import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final String? userId;

  UserService({this.userId});

  final firestore = FirebaseFirestore.instance;
  final CollectionReference userThemeCollection =
      FirebaseFirestore.instance.collection('user-theme');

  Future<void> addToUserThemes(String userId, String themeId) async {
    final DocumentReference userThemeRef =
        firestore.collection('user-theme').doc(userId);
    final DocumentSnapshot userThemeSnapshot = await userThemeRef.get();

    if (userThemeSnapshot.exists) {
      final List<String> themes = List<String>.from(
          (userThemeSnapshot.data() as Map<String, dynamic>)['themes'] ?? []);
      themes.add(themeId);
      print(themeId);

      await userThemeRef.update({'themes': themes});
    } else {
      await userThemeRef.set({
        'themes': [themeId]
      });
    }
  }

  Future<void> updateUserData(userThemeData) async {
    return await userThemeCollection.doc(userId).set(userThemeData);
  }

  Future<List<String>> getUserThemeById(String userId) async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('user-theme')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['themes'] is List) {
        final List<dynamic> themes = data['themes'];
        return themes.cast<String>();
      }
    }
    return [];
  }

  Future<String?> getUserIdByEmail(String email) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('user-theme')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Assuming email is unique, return the ID of the first matching user
      return querySnapshot.docs.first.id;
    } else {
      return null; // User with the specified email not found
    }
  }
}
