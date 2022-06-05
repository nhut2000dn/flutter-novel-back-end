import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorModel {
  static const ID = "uid";
  static const NAME = "name";
  static const DESCRIPTION = "description";
  static const AVATAR = "avatar";

  late String _id;
  late String _name;
  late String _description;
  late String _avatar;

//  getters
  String get id => _id;
  String get name => _name;
  String get description => _description;
  String get avatar => _avatar;

  AuthorModel.fromSnapshot(DocumentSnapshot snapshot) {
    _avatar = snapshot[AVATAR];
    _description = snapshot[DESCRIPTION];
    _name = snapshot[NAME];
    _id = snapshot.id;
  }
}
