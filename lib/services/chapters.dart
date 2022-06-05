import 'package:admin_dashboard/models/chapters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';
import 'package:flutter/cupertino.dart';

class ChapterService {
  String chaptersCollection = "chapters";

  Future<List<ChapterModel>> getChaptersOfNovel(String id) async =>
      firebaseFiretore
          .collection(chaptersCollection)
          .where('novel_id', isEqualTo: id)
          .get()
          .then((result) {
        List<ChapterModel> chapters = [];
        for (DocumentSnapshot chapter in result.docs) {
          chapters.add(ChapterModel.fromSnapshot(chapter));
        }
        return chapters;
      });

  Future<bool> addChapter(Map<String, dynamic> values) async => firebaseFiretore
          .collection(chaptersCollection)
          .add(values)
          .then((result) {
        return true;
      });

  Future<bool> updateChapter(String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(chaptersCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteChapter(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(chaptersCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
