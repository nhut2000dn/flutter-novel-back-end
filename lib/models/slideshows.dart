import 'package:cloud_firestore/cloud_firestore.dart';

class SlideshowModel {
  static const ID = "uid";
  static const TITLE = "title";
  static const IMAGE = "image";
  static const INDEX = "index";
  static const NOVELID = "novel_id";

  late String _id;
  late String _title;
  late String _image;
  late int _index;
  late String _novelId;

//  getters
  String get id => _id;
  String get title => _title;
  String get image => _image;
  int get index => _index;
  String get novelId => _novelId;

  SlideshowModel();

  SlideshowModel.fromSnapshot(DocumentSnapshot snapshot) {
    _novelId = snapshot[NOVELID];
    _index = snapshot[INDEX];
    _image = snapshot[IMAGE];
    _title = snapshot[TITLE];
    _id = snapshot.id;
  }
}
