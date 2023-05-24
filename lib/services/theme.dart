import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/theme.dart';

class ThemeService {
  final String? themeId;

  ThemeService({this.themeId});

  final firestore = FirebaseFirestore.instance;
  final CollectionReference themeCollection =
      FirebaseFirestore.instance.collection('theme');

  Future<String> addTheme(themeData) async {
    var id = await themeCollection.add(themeData).then((value) => value.id);
    print('we arw in the funsiton');
    print(id);
    return id;
  }

  Future<SpacyTheme?> getThemeById(String themeId) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('theme').doc(themeId).get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>?;
      SpacyTheme theme = SpacyTheme(
          uid: themeId, deadline: data!['deadline'], name: data['name']);
      return theme;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getThemesByIdsForActive2(
      List<String> listOfIds) async {
    print('Active');
    final DateTime now = DateTime.now();
    final Timestamp today =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    final QuerySnapshot snapshot = await firestore
        .collection('theme')
        .where(FieldPath.documentId, whereIn: listOfIds)
        .get();

    final List<Map<String, dynamic>> themes = snapshot.docs
        .where((element) => element['deadline'] == null
            ? true
            : element['deadline'].toDate().isAfter(now))
        .map((DocumentSnapshot doc) => {
              'name': doc['name'],
              'id': doc.id,
            })
        .toList();

    return themes;
  }

  Future<List<Map<String, dynamic>>> getThemesByIdsForActive(
      List<String> listOfIds) async {
    print('All');
    final DateTime now = DateTime.now();
    final Timestamp today =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    final List<Map<String, dynamic>> themes = [];

    final batchSize = 10; // Maximum number of IDs per batch
    final totalBatches = (listOfIds.length / batchSize).ceil();

    for (var i = 0; i < totalBatches; i++) {
      final start = i * batchSize;
      final end = (i + 1) * batchSize;

      final List<String> batchIds = listOfIds.sublist(
          start, end > listOfIds.length ? listOfIds.length : end);

      final QuerySnapshot snapshot = await firestore
          .collection('theme')
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      final List<Map<String, dynamic>> batchThemes = snapshot.docs
          .map((DocumentSnapshot doc) => {
                'name': doc['name'],
                'id': doc.id,
                // Include other attributes here
              })
          .where((element) => element['deadline'] == null
              ? true
              : element['deadline'].toDate().isAfter(now))
          .toList();

      themes.addAll(batchThemes);
    }

    return themes;
  }

  Future<List<Map<String, dynamic>>> getThemesByIdsForAll(
      List<String> listOfIds) async {
    print('All');
    final DateTime now = DateTime.now();
    final Timestamp today =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    final List<Map<String, dynamic>> themes = [];

    final batchSize = 10; // Maximum number of IDs per batch
    final totalBatches = (listOfIds.length / batchSize).ceil();

    for (var i = 0; i < totalBatches; i++) {
      final start = i * batchSize;
      final end = (i + 1) * batchSize;

      final List<String> batchIds = listOfIds.sublist(
          start, end > listOfIds.length ? listOfIds.length : end);

      final QuerySnapshot snapshot = await firestore
          .collection('theme')
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      final List<Map<String, dynamic>> batchThemes = snapshot.docs
          .map((DocumentSnapshot doc) => {
                'name': doc['name'],
                'id': doc.id,
                // Include other attributes here
              })
          .toList();

      themes.addAll(batchThemes);
    }

    return themes;
  }

  Future<List<Map<String, dynamic>>> getThemesByIdsForToday(
      List<String> listOfIds) async {
    print('All');
    final DateTime now = DateTime.now();
    final Timestamp today =
        Timestamp.fromDate(DateTime(now.year, now.month, now.day));

    final List<Map<String, dynamic>> themes = [];

    final batchSize = 10; // Maximum number of IDs per batch
    final totalBatches = (listOfIds.length / batchSize).ceil();

    for (var i = 0; i < totalBatches; i++) {
      final start = i * batchSize;
      final end = (i + 1) * batchSize;

      final List<String> batchIds = listOfIds.sublist(
          start, end > listOfIds.length ? listOfIds.length : end);

      final QuerySnapshot snapshot = await firestore
          .collection('theme')
          .where(FieldPath.documentId, whereIn: batchIds)
          .get();

      final List<Map<String, dynamic>> batchThemes = snapshot.docs
          .map((DocumentSnapshot doc) => {
                'name': doc['name'],
                'id': doc.id,
                // Include other attributes here
              })
          .where((element) => element['firstDayToRepeat'] == null
              ? true
              : element['firstDayToRepeat'].toDate().isBefore(now))
          .toList();

      themes.addAll(batchThemes);
    }

    return themes;
  }
}
