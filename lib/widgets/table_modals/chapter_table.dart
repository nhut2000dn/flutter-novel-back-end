// ignore_for_file: deprecated_member_use
import 'package:admin_dashboard/models/chapters.dart';
import 'package:admin_dashboard/services/chapters.dart';
import 'package:admin_dashboard/widgets/add_modals/add_chapter.dart';
import 'package:admin_dashboard/widgets/edit_modals/edit_chapter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/services/user.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/responsive_table.dart';

// ignore: must_be_immutable
class ChapterTable extends StatefulWidget {
  String id;
  ChapterTable({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _ChapterTableState createState() => _ChapterTableState();
}

class _ChapterTableState extends State<ChapterTable>
    with AutomaticKeepAliveClientMixin<ChapterTable> {
  late TextEditingController inputSearchController;
  late bool isSearch = false;
  List<Map<String, dynamic>> chaptersTableSource = <Map<String, dynamic>>[];
  List<ChapterModel> _chapters = <ChapterModel>[];
  List<ChapterModel> get chapters => _chapters;
  bool isLoading = true;

  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> _getChaptersNovelData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _chapters.length;
    debugPrint(i.toString());
    for (ChapterModel chapterData in _chapters) {
      temps.add({
        "id": chapterData.id,
        "title": chapterData.title,
        "number_chapter": chapterData.numberChapter,
        "day_release": chapterData.dayRelease,
        "content": chapterData.content,
      });
      i++;
    }
    return temps;
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    debugPrint(widget.id);
    var placeholder = await ChapterService().getChaptersOfNovel(widget.id);
    setState(() {
      _chapters = placeholder;
      chaptersTableSource.addAll(_getChaptersNovelData());
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    inputSearchController = TextEditingController();
    chaptersTableSource.clear();
    initData();
  }

  updateTable(bool check) {
    if (check) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Add Chapter Succesful!")));
      chaptersTableSource.clear();
      initData();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Add Chapter failed!")));
    }
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
          text: "TITLE",
          value: "title",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "NUMBER CHAPTER",
          value: "number_chapter",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "DAY RELEASE",
          value: "day_release",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.left),
      DatatableHeader(
          text: "CONTENT",
          value: "content",
          show: true,
          flex: 2,
          sortable: true,
          sourceBuilder: (value, row) {
            return Text(
              value,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            );
          },
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
                        await UserServices().deleteUser(row['user_id']);
                    if (check) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Delete User Succesful!"),
                        ),
                      );
                      tablesProvider.refreshFromFirebase(Tables.users);
                    }
                  },
                ),
                InkWell(
                  child: Icon(
                    Icons.edit,
                    color: Colors.green[700],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: EditChapterPage(
                              idChapter: value,
                              chapter: row,
                              notifyAndRefresh: updateTable,
                            ));
                      },
                    );
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: AddChapterPage(
                                      idNovel: widget.id,
                                      notifyAndRefresh: updateTable,
                                    ));
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("ADD CHAPTER"))
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
                  source: chaptersTableSource,
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
