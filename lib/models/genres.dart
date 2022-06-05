import 'package:cloud_firestore/cloud_firestore.dart';

class GenreModel {
  static const ID = "uid";
  static const NAME = "name";
  static const DESCRIPTION = "description";
  static const IMAGE = "image";

  late String _id;
  late String _name;
  late String _description;
  late String _image;

//  getters
  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get image => _image;

  GenreModel();

  GenreModel.fromSnapshot(DocumentSnapshot snapshot) {
    _image = snapshot[IMAGE];
    _description = snapshot[DESCRIPTION];
    _name = snapshot[NAME];
    _id = snapshot.id;
  }
}
