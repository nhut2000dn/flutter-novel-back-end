import 'package:admin_dashboard/models/novels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';

class NovelService {
  String novelsCollection = "novels";

  Future<List<NovelModel>> getAllNovels() async =>
      firebaseFiretore.collection(novelsCollection).get().then((result) {
        List<NovelModel> novels = [];
        for (DocumentSnapshot novel in result.docs) {
          novels.add(NovelModel.fromSnapshot(novel));
        }
        return novels;
      });

  Future<bool> addNovel(Map<String, dynamic> values) async =>
      firebaseFiretore.collection(novelsCollection).add(values).then((result) {
        return true;
      });

  Future<bool> updateNovel(String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(novelsCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteNovel(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(novelsCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
