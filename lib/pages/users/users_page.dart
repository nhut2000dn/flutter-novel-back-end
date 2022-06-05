// ignore_for_file: deprecated_member_use
import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/rounting/route_names.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/user.dart';
import 'package:admin_dashboard/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/responsive_table.dart';

import '../../locator.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late TextEditingController inputSearchController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    inputSearchController = TextEditingController();
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
          text: "Gender",
          value: "gender",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "User Role",
          value: "userRole",
          show: true,
          flex: 2,
          sortable: true,
          sourceBuilder: (value, row) {
            return Text(tablesProvider.usersRolesTableSource
                .where((element) => element['id'] == value)
                .first['role']);
          },
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
                    bool check =
                        await UserServices().deleteUser(row['user_id']);
                    if (check) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Delete User Succesful!"),
                        ),
                      );
                      tablesProvider.removeFromTable(Tables.users, value);
                    }
                  },
                ),
                InkWell(
                  child: Icon(
                    Icons.edit,
                    color: Colors.green[700],
                  ),
                  onTap: () {
                    locator<NavigationService>()
                        .navigateToWithArgument(EditUserRoute, row);
                  },
                ),
              ],
            );
          },
          textAlign: TextAlign.center),
    ];

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const PageHeader(
            text: 'USERS',
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(0),
            constraints: const BoxConstraints(
              maxHeight: 700,
            ),
            child: Card(
              elevation: 1,
              shadowColor: Colors.black,
              clipBehavior: Clip.none,
              child: ResponsiveDatatable(
                title: !tablesProvider.isSearch
                    ? RaisedButton.icon(
                        onPressed: () {
                          locator<NavigationService>().navigateTo(AddUserRoute);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("ADD USER"))
                    : null,
                actions: [
                  if (tablesProvider.isSearch)
                    DropdownButton(
                      itemHeight: 64,
                      value: tablesProvider.fieldUserCurrent,
                      items: tablesProvider.fieldsUser
                          .map(
                            (value) => DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        debugPrint(value.toString());
                        tablesProvider.onChangeFieldCurrent(
                          Tables.users,
                          value.toString(),
                        );
                      },
                    ),
                  if (tablesProvider.isSearch)
                    Expanded(
                      child: TextField(
                        controller: inputSearchController,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              setState(
                                () {
                                  tablesProvider.isSearch = false;
                                  tablesProvider.resestData(Tables.users);
                                },
                              );
                            },
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              tablesProvider.onSearch(
                                  Tables.users, inputSearchController.text);
                            },
                          ),
                        ),
                      ),
                    ),
                  if (!tablesProvider.isSearch)
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(
                          () {
                            tablesProvider.isSearch = true;
                          },
                        );
                      },
                    )
                ],
                headers: usersTableHeader,
                source: tablesProvider.usersTableSource,
                selecteds: tablesProvider.selecteds,
                showSelect: tablesProvider.showSelect,
                autoHeight: false,
                onTabRow: (data) {
                  debugPrint('data');
                },
                onSort: (value) => tablesProvider.onSort(value, Tables.users),
                sortAscending: tablesProvider.sortAscending,
                sortColumn: tablesProvider.sortColumn,
                isLoading: tablesProvider.isLoading,
                footers: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        "Number of Users: ${tablesProvider.usersTableSource.length}"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
