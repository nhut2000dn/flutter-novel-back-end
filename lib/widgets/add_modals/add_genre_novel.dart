// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

import 'package:admin_dashboard/models/genres.dart';
import 'package:admin_dashboard/services/novels_genres.dart';

// ignore: import_of_legacy_library_into_null_safe
// ignore: import_of_legacy_library_into_null_safe

import '../custom_text.dart';
import '../loading_opacity.dart';
import '../page_header.dart';

// ignore: must_be_immutable
class AddGenreNovels extends StatefulWidget {
  final String id;
  final List<GenreModel> genres;
  final Function notifyAndRefresh;

  const AddGenreNovels({
    Key? key,
    required this.id,
    required this.genres,
    required this.notifyAndRefresh,
  }) : super(key: key);

  @override
  _AddGenreNovelsState createState() => _AddGenreNovelsState();
}

class _AddGenreNovelsState extends State<AddGenreNovels> {
  late GenreModel genreCurrent;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  initData() async {
    setState(() {
      genreCurrent = widget.genres[0];
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Stack(
        children: [
          Opacity(
            opacity: isLoading
                ? 0.5
                : 1, // You can reduce this when loading to give different effect
            child: AbsorbPointer(
              absorbing: isLoading,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const PageHeader(
                      text: 'ADD GENRE',
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(
                        maxHeight: 190,
                        maxWidth: 300,
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
                                      padding:
                                          const EdgeInsets.only(bottom: 25.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: SizedBox(
                                              child: Text(
                                                'Genres: ',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                        color:
                                                            Colors.grey[200]),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: DropdownButton(
                                                        isExpanded: true,
                                                        value: genreCurrent,
                                                        items: widget.genres
                                                            .map(
                                                              (value) =>
                                                                  DropdownMenuItem(
                                                                child: Text(
                                                                    value.name),
                                                                value: value,
                                                              ),
                                                            )
                                                            .toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            genreCurrent = value
                                                                as GenreModel;
                                                          });
                                                          debugPrint(
                                                              value.toString());
                                                        },
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
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.indigo),
                                              child: FlatButton(
                                                onPressed: () async {
                                                  bool check =
                                                      await NovelsGenreService()
                                                          .addNovelGenre({
                                                    'genre_id': genreCurrent.id,
                                                    'novel_id': widget.id
                                                  });
                                                  if (check) {
                                                    Navigator.of(context).pop();
                                                  }
                                                  widget.notifyAndRefresh(
                                                      check, genreCurrent);
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      CustomText(
                                                        text: "ADD",
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
              ),
            ),
          ),
          Opacity(
              opacity: isLoading ? 1.0 : 0,
              child: isLoading ? const LoadingOpacity() : Container()),
        ],
      ),
    );
  }
}
