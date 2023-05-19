import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ThemeService {

  final String? themeId;
  ThemeService({ this.themeId });


  final firestore = FirebaseFirestore.instance;
  final CollectionReference themeCollection = FirebaseFirestore.instance.collection('theme');

  Future<String> addTheme(themeData) async {
    var id = await themeCollection.add(themeData).then((value) => value.id);
    return id;
  }

  Future<List<Map<String, dynamic>>> getThemesByIdsForToday(List<String> listOfIds) async {
    final DateTime now = DateTime.now();
    final Timestamp today = Timestamp.fromDate(DateTime(now.year, now.month, now.day));
    print(today);
    print(listOfIds);
    final QuerySnapshot snapshot = await firestore
        .collection('theme')
        .where(FieldPath.documentId, whereIn: listOfIds)
        .get();
    

    final List<Map<String, dynamic>> themes = snapshot.docs
        .where((element) => element['firstDayToRepeat'].toDate().isBefore(now))
        .map((DocumentSnapshot doc) => {
            'name': doc['name'],
              'id': doc.id,
          }).toList();

    return themes;
  }
}