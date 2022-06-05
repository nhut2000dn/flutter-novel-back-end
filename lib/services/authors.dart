import 'package:admin_dashboard/models/authors.dart';
import 'package:admin_dashboard/models/novels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';

class AuthorService {
  String AuthorsCollection = "authors";

  Future<List<AuthorModel>> getAllAuthors() async =>
      firebaseFiretore.collection(AuthorsCollection).get().then((result) {
        List<AuthorModel> authors = [];
        for (DocumentSnapshot author in result.docs) {
          authors.add(AuthorModel.fromSnapshot(author));
        }
        return authors;
      });

  Future<bool> addAuthor(Map<String, dynamic> values) async =>
      firebaseFiretore.collection(AuthorsCollection).add(values).then((result) {
        return true;
      });

  Future<bool> updateAuthor(String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(AuthorsCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<bool> deleteAuthor(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(AuthorsCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
