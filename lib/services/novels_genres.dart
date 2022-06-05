import 'package:admin_dashboard/models/genres.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';
import 'package:flutter/cupertino.dart';

class NovelsGenreService {
  String genresCollection = "genres";
  String novelsGenresCollection = "novels_genres";

  Future<List<GenreModel>> getAllGenresOfNovel(String idNovel) async {
    List<String> genreIds = [];
    List<GenreModel> genres = [];
    bool check = false;
    await firebaseFiretore
        .collection(novelsGenresCollection)
        .where('novel_id', isEqualTo: idNovel)
        .get()
        .then((result) async {
      for (DocumentSnapshot genreNovel in result.docs) {
        genreIds.add(genreNovel['genre_id']);
        check = true;
      }
    });
    if (check) {
      await firebaseFiretore
          .collection(genresCollection)
          .where(
            '__name__',
            whereIn: genreIds,
          )
          .get()
          .then((result) {
        for (DocumentSnapshot novel in result.docs) {
          genres.add(GenreModel.fromSnapshot(novel));
        }
      });
    }
    return genres;
  }

  Future<bool> addNovelGenre(Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(novelsGenresCollection)
          .add(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteNovelGenre(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(novelsGenresCollection)
        .where('genre_id', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
