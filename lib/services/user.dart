import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:admin_dashboard/helpers/costants.dart';
import 'package:admin_dashboard/models/users.dart';
import 'package:admin_dashboard/services/users_roles.dart';
import 'package:firebase_core/firebase_core.dart';

import '../locator.dart';
import 'navigation_service.dart';

class UserServices {
  String usersCollection = "profiles";

  void createAdmin({
    required String id,
    required String email,
  }) {
    firebaseFiretore.collection(usersCollection).doc(id).set({
      "id": id,
      "email": email,
    });
  }

  Future<bool> createUserWithEmailAndPassword(
      String email, String password, String role) async {
    bool check = false;
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    try {
      await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password)
          .then((dynamic user) async {
        String uid = user.user.uid;
        String email = user.user.email;
        await firebaseFiretore.collection('profiles').add({
          'email': email,
          'fullName': '',
          'gender': '',
          'avatar': '',
          'user_role_id':
              role == 'admin' ? 'SfTnxSIC6mitc0QilJj7' : 'ZtUPmbeD9qrsiQO6WmgD',
          'user_id': uid
        }).then((result) async {
          check = true;
          await app.delete();
        });
      });
    } on FirebaseAuthException catch (e) {
      await app.delete();
    }
    return check;
  }

  Future<bool> updateUserData(String id, Map<String, dynamic> values) async {
    bool check = false;
    await firebaseFiretore
        .collection(usersCollection)
        .doc(id)
        .update(values)
        .then((result) {
      check = true;
    });
    return check;
  }

  Future<bool> deleteUser(String id) async {
    bool check = false;
    var docs = await firebaseFiretore
        .collection('profiles')
        .where('user_id', isEqualTo: id)
        .get();
    for (var element in docs.docs) {
      element.reference.delete();
      check = true;
    }
    return check;
  }

  Future<UserModel> getAdminById(String id) => firebaseFiretore
          .collection(usersCollection)
          .where('user_id', isEqualTo: id)
          .where('user_role_id', isEqualTo: 'SfTnxSIC6mitc0QilJj7')
          .get()
          .then((document) {
        return UserModel.fromSnapshot(document.docs[0]);
      });

  Future<List<UserModel>> getAllUsers() async =>
      firebaseFiretore.collection(usersCollection).get().then((result) {
        List<UserModel> users = [];
        for (DocumentSnapshot user in result.docs) {
          users.add(UserModel.fromSnapshot(user));
        }
        return users;
      });

  Future<UserModel> getUserById(String id) async => firebaseFiretore
          .collection(usersCollection)
          .where('user_id', isEqualTo: id)
          .get()
          .then((result) {
        UserModel user = {} as UserModel;
        for (DocumentSnapshot doc in result.docs) {
          user = doc as UserModel;
        }
        return user;
      });
}
