// ignore_for_file: deprecated_member_use
import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/services/user.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:flutter/foundation.dart';
import 'package:admin_dashboard/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_dashboard/services/navigation_service.dart';

import '../../locator.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

enum SingingCharacter { male, female }

class _AddUserPageState extends State<AddUserPage> {
  final UserServices _userServices = UserServices();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<bool> addUserToFirebase(
      String email, String password, String role) async {
    return await _userServices.createUserWithEmailAndPassword(
        email, password, role);
  }

  @override
  Widget build(BuildContext context) {
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            text: 'ADD USER',
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(0),
            constraints: const BoxConstraints(
              maxHeight: 600,
              maxWidth: 700,
            ),
            child: Card(
              elevation: 1,
              shadowColor: Colors.black,
              clipBehavior: Clip.none,
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'email',
                                    icon: Icon(Icons.email_outlined)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    icon: Icon(Icons.lock_open)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration:
                                const BoxDecoration(color: Colors.indigo),
                            child: FlatButton(
                              onPressed: () async {
                                if (await addUserToFirebase(
                                    _emailController.text,
                                    _passwordController.text,
                                    'user')) {
                                  locator<NavigationService>().goBack();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("Add User Succesful!")));
                                  tablesProvider
                                      .refreshFromFirebase(Tables.users);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Add User failed!")));
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CustomText(
                                      text: "REGISTER",
                                      size: 22,
                                      color: Colors.white,
                                      weight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
