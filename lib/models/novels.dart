import 'package:cloud_firestore/cloud_firestore.dart';

class NovelModel {
  static const ID = "uid";
  static const NAME = "name";
  static const READER = "reader";
  static const FOLLOWER = "follower";
  static const CHAPTER = "chapter";
  static const STATUS = "status";
  static const YEARRELEASE = "year_release";
  static const DESCRIPTION = "description";
  static const IMAGE = "image";
  static const AUTHORID = "author_id";

  late String _id;
  late String _name;
  late int _reader;
  late int _follower;
  late int _chapter;
  late bool _status;
  late int _yearRelease;
  late String _description;
  late String _image;
  late String _authorId;

//  getters
  String get id => _id;
  String get name => _name;
  int get reader => _reader;
  int get follower => _follower;
  int get chapter => _chapter;
  bool get status => _status;
  int get yearRelease => _yearRelease;
  String get description => _description;
  String get image => _image;
  String get authorId => _authorId;

  NovelModel.fromSnapshot(DocumentSnapshot snapshot) {
    _authorId = snapshot[AUTHORID];
    _image = snapshot[IMAGE];
    _description = snapshot[DESCRIPTION];
    _yearRelease = snapshot[YEARRELEASE];
    _status = snapshot[STATUS];
    _chapter = snapshot[CHAPTER];
    _follower = snapshot[FOLLOWER];
    _reader = snapshot[READER];
    _name = snapshot[NAME];
    _id = snapshot.id;
  }
}
