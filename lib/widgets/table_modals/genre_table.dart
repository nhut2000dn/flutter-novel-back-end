// ignore_for_file: deprecated_member_use
import 'package:admin_dashboard/models/genres.dart';
import 'package:admin_dashboard/services/genre.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/novels_genres.dart';
import 'package:admin_dashboard/widgets/add_modals/add_genre_novel.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/services/user.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/responsive_table.dart';

import '../../locator.dart';
import '../custom_text.dart';
import '../loading_opacity.dart';
import '../page_header.dart';

// ignore: must_be_immutable
class GenreTable extends StatefulWidget {
  String id;
  GenreTable({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _GenreTableState createState() => _GenreTableState();
}

class _GenreTableState extends State<GenreTable>
    with AutomaticKeepAliveClientMixin<GenreTable> {
  late TextEditingController inputSearchController;
  late bool isSearch = false;
  List<Map<String, dynamic>> genreTableSource = <Map<String, dynamic>>[];
  List<GenreModel> _genres = <GenreModel>[];
  List<GenreModel> _allGenres = <GenreModel>[];
  List<GenreModel> get genres => _genres;
  bool isLoading = true;

  @override
  bool get wantKeepAlive => true;

  List<Map<String, dynamic>> _getGenresData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = _genres.length;
    debugPrint(i.toString());
    for (GenreModel genreData in _genres) {
      temps.add({
        "id": genreData.id,
        "name": genreData.name,
        "description":
            (genreData.description != '') ? genreData.description : 'Null',
        "image": (genreData.image != '') ? genreData.image : '',
      });
      i++;
    }
    return temps;
  }

  updateTable(bool check, GenreModel genre) {
    if (check) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Add Genre Succesful!")));
      setState(() {
        genreTableSource.add({
          "id": genre.id,
          "name": genre.name,
          "description": (genre.description != '') ? genre.description : 'Null',
          "image": (genre.image != '') ? genre.image : '',
        });
        genres.add(genre);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Add Genre failed!")));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    debugPrint(widget.id);
    var placeholderGenresOfNovel =
        await NovelsGenreService().getAllGenresOfNovel(widget.id);
    var placeholderAllGenres = await GenreService().getAllGenres();
    setState(() {
      _genres = placeholderGenresOfNovel;
      _allGenres = placeholderAllGenres;
      genreTableSource.addAll(_getGenresData());
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
    List<DatatableHeader> usersTableHeader = [
      DatatableHeader(
          text: "ID",
          value: "id",
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
          text: "Description",
          value: "description",
          show: true,
          flex: 2,
          sortable: true,
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
                    bool check =
                        await NovelsGenreService().deleteNovelGenre(value);
                    if (check) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Delete Genre Succesful!"),
                        ),
                      );
                      setState(() {
                        genreTableSource
                            .removeWhere((element) => element['id'] == value);
                        _genres.removeWhere((element) => element.id == value);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Delete Genre Fail!"),
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
                            List<GenreModel> genres = [];
                            bool check = true;
                            for (var i in _allGenres) {
                              check = true;
                              for (var j in _genres) {
                                if (i.id == j.id) {
                                  check = false;
                                }
                              }
                              if (check) {
                                genres.add(i);
                              }
                            }
                            debugPrint(genres.toString());
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: AddGenreNovels(
                                      genres: genres,
                                      id: widget.id,
                                      notifyAndRefresh: updateTable,
                                    ));
                              },
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("ADD GENRE"))
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
                  source: genreTableSource,
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
