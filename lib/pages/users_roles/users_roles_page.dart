// ignore_for_file: deprecated_member_use

import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/rounting/route_names.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/users_roles.dart';
import 'package:admin_dashboard/widgets/page_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/responsive_table.dart';

import '../../locator.dart';

class UsersRolesPage extends StatefulWidget {
  const UsersRolesPage({Key? key}) : super(key: key);

  @override
  _UsersRolesPageState createState() => _UsersRolesPageState();
}

class _UsersRolesPageState extends State<UsersRolesPage> {
  final UserRoleService _userRoleService = UserRoleService();
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

    List<DatatableHeader> usersRolesTableHeader = [
      DatatableHeader(
          text: "ID",
          value: "id",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Role",
          value: "role",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Description",
          value: "description",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
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
                        await _userRoleService.deleteUserRole(row['id']);
                    if (check) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Delete User Role Succesful!"),
                        ),
                      );
                      tablesProvider.removeFromTable(Tables.usersRoles, value);
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
                        .navigateToWithArgument(EditUserRoleRoute, row);
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
            text: 'USERS ROLES',
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
                          locator<NavigationService>()
                              .navigateTo(AddUserRoleRoute);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("ADD USER ROLE"))
                    : null,
                actions: [
                  if (tablesProvider.isSearch)
                    DropdownButton(
                      itemHeight: 64,
                      value: tablesProvider.fieldUserRoleCurrent,
                      items: tablesProvider.fieldsUserRole
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
                          Tables.usersRoles,
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
                                  tablesProvider.resestData(Tables.usersRoles);
                                },
                              );
                            },
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              tablesProvider.onSearch(Tables.usersRoles,
                                  inputSearchController.text);
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
                headers: usersRolesTableHeader,
                source: tablesProvider.usersRolesTableSource,
                autoHeight: false,
                onTabRow: (data) {
                  debugPrint(data);
                },
                onSort: (value) =>
                    tablesProvider.onSort(value, Tables.usersRoles),
                sortAscending: tablesProvider.sortAscending,
                sortColumn: tablesProvider.sortColumn,
                isLoading: tablesProvider.isLoading,
                footers: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        "Number of Users Roles: ${tablesProvider.usersRolesTableSource.length}"),
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
