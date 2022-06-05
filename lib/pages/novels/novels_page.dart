import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/rounting/route_names.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/novels.dart';
import 'package:admin_dashboard/widgets/page_header.dart';
import 'package:admin_dashboard/widgets/table_modals/chapter_table.dart';
import 'package:admin_dashboard/widgets/table_modals/follower_table.dart';
import 'package:admin_dashboard/widgets/table_modals/genre_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/responsive_table.dart';

import '../../locator.dart';

class NovelsPage extends StatefulWidget {
  const NovelsPage({Key? key}) : super(key: key);

  @override
  _NovelsPageState createState() => _NovelsPageState();
}

class _NovelsPageState extends State<NovelsPage> with TickerProviderStateMixin {
  late TextEditingController inputSearchController;
  late TabController _tabController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    inputSearchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    List<DatatableHeader> novelsTableHeader = [
      DatatableHeader(
          text: "ID",
          value: "id",
          show: false,
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
          text: "Reader",
          value: "reader",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Follower",
          value: "follower",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Chapter",
          value: "chapter",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Status",
          value: "status",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Year Release",
          value: "year_release",
          show: true,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Author",
          value: "author_id",
          show: true,
          sortable: true,
          sourceBuilder: (value, row) {
            return Text(tablesProvider.authorsTableSource
                .where((element) => element['id'] == value)
                .first['name']);
          },
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Description",
          value: "description",
          show: true,
          sortable: true,
          sourceBuilder: (value, row) {
            return Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            );
          },
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "Image",
          value: "image",
          show: true,
          flex: 1,
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
                    bool check = await NovelService().deleteNovel(value);
                    if (check) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Delete Novel Succesful!"),
                        ),
                      );
                      tablesProvider.removeFromTable(Tables.novels, value);
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
                        .navigateToWithArgument(EditNovelRoute, row);
                  },
                ),
                InkWell(
                  child: const Icon(Icons.remove_red_eye),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TabBar(
                                      controller: _tabController,
                                      tabs: const [
                                        Tab(
                                          child: Text(
                                            'Chapters',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 19),
                                          ),
                                        ),
                                        Tab(
                                          child: Text(
                                            'Followers',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 19),
                                          ),
                                        ),
                                        Tab(
                                          child: Text(
                                            'Genres',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 19),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        controller: _tabController,
                                        children: [
                                          ChapterTable(id: value),
                                          FollowerTable(id: value),
                                          GenreTable(id: value),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
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
            text: 'NOVELS',
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(0),
            constraints: const BoxConstraints(
              maxHeight: 600,
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
                              .navigateTo(AddNovelRoute);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("ADD NOVEL"))
                    : null,
                actions: [
                  if (tablesProvider.isSearch)
                    DropdownButton(
                      itemHeight: 64,
                      value: tablesProvider.fieldNovelCurrent,
                      items: tablesProvider.fieldsNovel
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
                          Tables.novels,
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
                                  tablesProvider.resestData(Tables.novels);
                                },
                              );
                            },
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              tablesProvider.onSearch(
                                  Tables.novels, inputSearchController.text);
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
                headers: novelsTableHeader,
                source: tablesProvider.novelsTableSource,
                selecteds: tablesProvider.selecteds,
                showSelect: tablesProvider.showSelect,
                autoHeight: false,
                onSort: (value) => tablesProvider.onSort(value, Tables.novels),
                sortAscending: tablesProvider.sortAscending,
                sortColumn: tablesProvider.sortColumn,
                isLoading: tablesProvider.isLoading,
                onSelect: tablesProvider.onSelected,
                onSelectAll: tablesProvider.onSelectAll,
                footers: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        "Number of Novels: ${tablesProvider.usersTableSource.length}"),
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
