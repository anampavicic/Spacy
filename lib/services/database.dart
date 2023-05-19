import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserService {

  final String? userId;
  UserService({ this.userId });

  final userThemeData = {'Themes': ['theme_id_1', 'theme_id_2', 'theme_id_3', 'theme_id_4']};
  final firestore = FirebaseFirestore.instance;
  final CollectionReference userThemeCollection = FirebaseFirestore.instance.collection('user-theme');

  Future<void> addToUserThemes(String userId, String themeId) async {
    final DocumentReference userThemeRef = firestore.collection('user-theme').doc(userId);
    final DocumentSnapshot userThemeSnapshot = await userThemeRef.get();

    if (userThemeSnapshot.exists) {
      final List<String> themes =
      List<String>.from((userThemeSnapshot.data() as Map<String, dynamic>)['Themes'] ?? []);
      themes.add(themeId);

      await userThemeRef.update({'Themes': themes});
    } else {
      await userThemeRef.set({'Themes': [themeId]});
    }
  }

  Future<void> updateUserData() async {
    return await userThemeCollection.doc(userId).set(userThemeData);
  }

  Future<List<String>> getUserThemeById(String userId) async {
    final DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('user-theme').doc(userId).get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>?;
      if (data != null && data['Themes'] is List) {
        final List<dynamic> themes = data['Themes'];
        return themes.cast<String>();
      }
    }
    return [];
  }

}