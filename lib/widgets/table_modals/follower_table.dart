// ignore_for_file: deprecated_member_use
import 'package:admin_dashboard/models/users.dart';
import 'package:admin_dashboard/services/users_novels.dart';
import 'package:admin_dashboard/widgets/add_modals/add_user_novel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/services/user.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/responsive_table.dart';

// ignore: must_be_immutable
class FollowerTable extends StatefulWidget {
  String id;
  FollowerTable({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _FollowerTableState createState() => _FollowerTableState();
}

class _FollowerTableState extends State<FollowerTable>
    with AutomaticKeepAliveClientMixin<FollowerTable> {
  @override
  bool get wantKeepAlive => true;

  late TextEditingController inputSearchController;
  late bool isSearch = false;
  List<Map<String, dynamic>> usersTableSource = <Map<String, dynamic>>[];
  List<UserModel> _users = <UserModel>[];
  List<UserModel> get users => _users;
  List<UserModel> _allUsers = <UserModel>[];
  bool isLoading = true;

  List<Map<String, dynamic>> _getUsersFollowedData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _users.length;
    debugPrint(i.toString());
    for (UserModel userData in _users) {
      temps.add({
        "id": userData.id,
        "email": userData.email,
        "name": (userData.fullName != '') ? userData.fullName : 'Null',
        "avatar": userData.avatar,
        "user_id": userData.userId,
      });
      i++;
    }
    return temps;
  }

  updateTable(bool check, UserModel user) {
    if (check) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add Follower Succesful!")));
      setState(() {
        usersTableSource.add({
          "id": user.id,
          "email": user.email,
          "name": user.fullName,
          "avatar": user.avatar,
          "user_id": user.userId,
        });
        _users.add(user);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Add Follower failed!")));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    debugPrint(widget.id);
    var placeholderUsers =
        await UsersNovelsService().getAllUsersFollowed(widget.id);
    var placeholderAllUser = await UserServices().getAllUsers();
    setState(() {
      _users = placeholderUsers;
      _allUsers = placeholderAllUser;
      usersTableSource.addAll(_getUsersFollowedData());
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    inputSearchController = TextEditingController();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    List<DatatableHeader> usersTableHeader = [
      DatatableHeader(
          text: "ID",
          value: "id",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Email",
          value: "email",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Name",
          value: "name",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Avatar",
          value: "avatar",
          show: true,
          flex: 2,
          sortable: true,
          sourceBuilder: (value, row) {
            return SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircleAvatar(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: (value != '')
                        ? FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'images/loading.gif',
                            image: value)
                        : const Image(image: AssetImage('images/no_image.jpg')),
                  ),
                ),
                foregroundColor: Colors.black,
              ),
            );
          },
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Action",
          value: "id",
          show: true,
          sortable: true,
          sourceBuilder: (value, row) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red[700],
                  ),
                  onTap: () async {
                    bool check = await UsersNovelsService()
                        .deleteUserNovel(row['user_id']);
                    if (check) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Delete Follower Succesful!"),
                        ),
                      );
                      setState(() {
                        usersTableSource
                            .removeWhere((element) => element['id'] == value);
                        _users.removeWhere((element) => element.id == value);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Delete Follower Fail!"),
                        ),
                      );
                    }
                  },
                ),
              ],
            );
          },
          textAlign: TextAlign.center),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 625,
              ),
              child: Card(
                elevation: 1,
                shadowColor: Colors.black,
                clipBehavior: Clip.none,
                child: ResponsiveDatatable(
                  title: !isSearch
                      ? RaisedButton.icon(
                          onPressed: () {
                            List<UserModel> users = [];
                            bool check = true;
                            for (var i in _allUsers) {
                              check = true;
                              for (var j in _users) {
                                if (i.id == j.id) {
                                  check = false;
                                }
                              }
                              if (check) {
                                users.add(i);
                              }
                            }
                            debugPrint(users.toString());
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: AddUserNovels(
                                      users: users,
                                      id: widget.id,
                                      notifyAndRefresh: updateTable,
                                    ));
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("ADD FOLLOWER"))
                      : null,
                  actions: [
                    if (isSearch)
                      Expanded(
                        child: TextField(
                          controller: inputSearchController,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(
                                  () {
                                    isSearch = false;
                                  },
                                );
                              },
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    if (!isSearch)
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(
                            () {
                              isSearch = true;
                            },
                          );
                        },
                      )
                  ],
                  headers: usersTableHeader,
                  source: usersTableSource,
                  autoHeight: false,
                  onTabRow: (data) {
                    debugPrint(data);
                  },
                  isLoading: isLoading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
