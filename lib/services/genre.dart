import 'package:admin_dashboard/models/genres.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';
import 'package:flutter/cupertino.dart';

class GenreService {
  String genresCollection = "genres";

  Future<List<GenreModel>> getAllGenres() async =>
      firebaseFiretore.collection(genresCollection).get().then((result) {
        List<GenreModel> genres = [];
        for (DocumentSnapshot user in result.docs) {
          genres.add(GenreModel.fromSnapshot(user));
        }
        return genres;
      });

  Future<bool> addGenre(Map<String, dynamic> values) async =>
      firebaseFiretore.collection(genresCollection).add(values).then((result) {
        return true;
      });

  Future<bool> updateGenre(String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(genresCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteGenre(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(genresCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
