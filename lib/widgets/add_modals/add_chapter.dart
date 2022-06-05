// ignore_for_file: deprecated_member_use

import 'package:admin_dashboard/services/chapters.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/locator.dart';
import 'package:admin_dashboard/models/chapters.dart';
import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/users_roles.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:admin_dashboard/widgets/page_header.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import '../loading_opacity.dart';

// ignore: must_be_immutable
class AddChapterPage extends StatefulWidget {
  final String idNovel;
  final Function notifyAndRefresh;
  const AddChapterPage({
    Key? key,
    required this.idNovel,
    required this.notifyAndRefresh,
  }) : super(key: key);

  @override
  _AddChapterPageState createState() => _AddChapterPageState();
}

class _AddChapterPageState extends State<AddChapterPage> {
  final ChapterService _chapterServices = ChapterService();
  late TextEditingController _numberChapterController;
  late TextEditingController _titleController;
  late TextEditingController _dateReleaseController;
  late HtmlEditorController _contentController;
  bool isLoading = false;
  DateTime _selectedDate = DateTime.now();
  String result = '';
  int widgetIndex = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _numberChapterController = TextEditingController();
    _titleController = TextEditingController();
    _dateReleaseController = TextEditingController();
    _contentController = HtmlEditorController();
  }

  Future<bool> addChapterToFirebase(String title, int numberChapter,
      String content, DateTime dateRelease, String novelId) async {
    return await _chapterServices.addChapter({
      'title': title,
      'number_chapter': numberChapter,
      'content': content,
      'day_release': dateRelease,
      'novel_id': novelId,
    });
  }

  @override
  Widget build(BuildContext context) {
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    return SizedBox(
      height: 800,
      width: 700,
      child: Stack(
        children: [
          Opacity(
            opacity: isLoading
                ? 0.5
                : 1, // You can reduce this when loading to give different effect
            child: AbsorbPointer(
              absorbing: isLoading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(
                    text: 'ADD CHAPTER',
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
                                              'Title: ',
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: TextField(
                                                      controller:
                                                          _titleController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter title you want',
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SizedBox(
                                            child: Text(
                                              'Number chapter: ',
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: TextField(
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          _numberChapterController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter number chapter',
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SizedBox(
                                            child: Text(
                                              'Content: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        IndexedStack(
                                          index: widgetIndex,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Container(
                                                height: 273,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  border: Border.all(
                                                    color: Color(0xffbabfc4),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: HtmlEditor(
                                                  controller:
                                                      _contentController,
                                                  htmlEditorOptions:
                                                      const HtmlEditorOptions(
                                                    hint: 'Your text here...',
                                                    shouldEnsureVisible: true,
                                                  ),
                                                  htmlToolbarOptions:
                                                      const HtmlToolbarOptions(
                                                    toolbarPosition: ToolbarPosition
                                                        .aboveEditor, //by default
                                                    toolbarType: ToolbarType
                                                        .nativeScrollable, //by default
                                                  ),
                                                  otherOptions:
                                                      const OtherOptions(
                                                    height: 200,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              color: Colors.grey[200],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: SizedBox(
                                            child: Text(
                                              'Day Release: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200]),
                                            child: TextField(
                                              focusNode:
                                                  AlwaysDisabledFocusNode(),
                                              controller:
                                                  _dateReleaseController,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Choose date time release',
                                              ),
                                              onTap: () {
                                                _selectDate(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      100, 10, 100, 10),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.indigo),
                                      child: FlatButton(
                                        onPressed: () async {
                                          bool check =
                                              await addChapterToFirebase(
                                            _titleController.text,
                                            int.parse(
                                                _numberChapterController.text),
                                            await _contentController.getText(),
                                            _selectedDate,
                                            widget.idNovel,
                                          );
                                          widget.notifyAndRefresh(check);
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
          Opacity(
              opacity: isLoading ? 1.0 : 0,
              child: isLoading ? const LoadingOpacity() : Container()),
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    setState(() {
      widgetIndex = 1;
    });
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.blue[500],
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _dateReleaseController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _dateReleaseController.text.length,
            affinity: TextAffinity.upstream));
    }
    setState(() {
      widgetIndex = 0;
    });
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
