// ignore_for_file: deprecated_member_use

import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/locator.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/users_roles.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/widgets/page_header.dart';

// ignore: must_be_immutable
class AddUserRolePage extends StatefulWidget {
  const AddUserRolePage({Key? key}) : super(key: key);

  @override
  _AddUserRolePageState createState() => _AddUserRolePageState();
}

class _AddUserRolePageState extends State<AddUserRolePage> {
  final UserRoleService _userRoleServices = UserRoleService();
  late TextEditingController _descriptionController;
  late TextEditingController _roleController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _roleController = TextEditingController();
  }

  Future<bool> addUserRoleToFirebase(String role, String description) async {
    return await _userRoleServices
        .addUserRole({'role': role, 'description': description});
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
            text: 'ADD USER ROLE',
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
                        Container(
                          color: const Color(0xffFFFFFF),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(
                                  height: 20,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: SizedBox(
                                    child: Text(
                                      'Role: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: TextField(
                                              controller: _roleController,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Enter role you want',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: SizedBox(
                                    child: Text(
                                      'Description: ',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: TextField(
                                              controller:
                                                  _descriptionController,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Enter Description of role',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _getActionButtons(context, '', tablesProvider)
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

  Widget _getActionButtons(
      BuildContext context, String id, TablesProvider tablesProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.indigo),
                  child: FlatButton(
                    onPressed: () async {
                      if (await addUserRoleToFirebase(
                        _roleController.text,
                        _descriptionController.text,
                      )) {
                        locator<NavigationService>().goBack();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Add User Role Succesful!")));
                        tablesProvider.refreshFromFirebase(Tables.usersRoles);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Add User Role failed!")));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CustomText(
                            text: "SAVE",
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
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Container(
                decoration: const BoxDecoration(color: Colors.redAccent),
                child: FlatButton(
                  onPressed: () {
                    setState(() {
                      locator<NavigationService>().goBack();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CustomText(
                          text: "CANCEL",
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
            flex: 2,
          ),
        ],
      ),
    );
  }
}
