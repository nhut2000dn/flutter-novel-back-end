import 'dart:async';

import 'package:admin_dashboard/helpers/costants.dart';
import 'package:admin_dashboard/models/users.dart';
import 'package:admin_dashboard/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthProvider with ChangeNotifier {
  late User _user;
  late Status _status = Status.Uninitialized;
  late UserServices _userServices = UserServices();
  late UserModel _userModel;
  late String _avatar;

//  getter
  UserModel get userModel => _userModel;
  Status get status => _status;
  User get user => _user;
  String get avatar => _avatar;

  // public variables
  var formkey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  AuthProvider.initialize() {
    _fireSetUp();
  }

  _fireSetUp() async {
    await initialization.then((value) {
      auth.authStateChanges().listen(_onStateChanged);
    });
  }

  Future<bool> signIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((value) async {
        await prefs.setString("id", value.user!.uid);
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("id", result.user!.uid);
        _userServices.createAdmin(
          id: result.user!.uid,
          email: email.text.trim(),
        );
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    password.text = "";
    email.text = "";
  }

  Future<void> reloadUserModel() async {
    _userModel = await _userServices.getAdminById(user.uid);
    notifyListeners();
  }

  _onStateChanged(User? firebaseUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      await prefs.setString("id", firebaseUser.uid);
      debugPrint(firebaseUser.uid);
      _userModel = await _userServices.getAdminById(user.uid).then((value) {
        _status = Status.Authenticated;
        return value;
      });
      // debugPrint(_userModel.email);
    }
    notifyListeners();
  }

  String validateEmail(String value) {
    value = value.trim();

    if (email.text != null) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }

    return 'null';
  }
}
