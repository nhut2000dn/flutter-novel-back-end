import 'package:admin_dashboard/models/genres.dart';
import 'package:admin_dashboard/models/users_roles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin_dashboard/helpers/costants.dart';

class UserRoleService {
  String usersRoleCollection = "users_roles";

  Future<String> getUserRoleId(String role) async {
    QuerySnapshot userData = await firebaseFiretore
        .collection(usersRoleCollection)
        .where('role', isEqualTo: role)
        .get();
    String documentId = userData.docs[0].id;

    return documentId;
  }

  Future<bool> addUserRole(Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(usersRoleCollection)
          .add(values)
          .then((result) {
        return true;
      });

  Future<bool> updateUserRole(String id, Map<String, dynamic> values) async =>
      firebaseFiretore
          .collection(usersRoleCollection)
          .doc(id)
          .update(values)
          .then((result) {
        return true;
      });

  Future<List<UserRoleModel>> getAllUsersRoles() async =>
      firebaseFiretore.collection(usersRoleCollection).get().then((result) {
        List<UserRoleModel> usersRoles = [];
        for (DocumentSnapshot user in result.docs) {
          usersRoles.add(UserRoleModel.fromSnapshot(user));
        }
        return usersRoles;
      });

  Future<bool> deleteUserRole(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection(usersRoleCollection)
        .where('__name__', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }
}
