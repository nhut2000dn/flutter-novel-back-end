import 'package:cloud_firestore/cloud_firestore.dart';

class UserRoleModel {
  static const ID = "uid";
  static const ROLE = "role";
  static const DESCRIPTION = "description";

  late String _id;
  late String _role;
  late String _description;

//  getters
  String get id => _id;
  String get role => _role;
  String get description => _description;

  UserRoleModel.fromSnapshot(DocumentSnapshot snapshot) {
    _description = snapshot[DESCRIPTION];
    _role = snapshot[ROLE];
    _id = snapshot.id;
  }
}
