import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const ID = "uid";
  static const FULLNAME = "fullName";
  static const EMAIL = "email";
  static const GENDER = "gender";
  static const AVATAR = "avatar";
  static const USERID = "user_id";
  static const USERROLEID = "user_role_id";

  late String _id;
  late String _email;
  late String _fullName;
  late String _gender;
  late String _avatar;
  late String _userId;
  late String _userRoleId;

//  getters
  String get id => _id;
  String get email => _email;
  String get fullName => _fullName;
  String get gender => _gender;
  String get avatar => _avatar;
  String get userId => _userId;
  String get userRoleId => _userRoleId;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _userRoleId = snapshot[USERROLEID];
    _userId = snapshot[USERID];
    _avatar = snapshot[AVATAR];
    _gender = snapshot[GENDER];
    _fullName = snapshot[FULLNAME];
    _email = snapshot[EMAIL];
    _id = snapshot.id;
  }
}
