import 'package:cloud_firestore/cloud_firestore.dart';

class ChapterModel {
  static const ID = "uid";
  static const TITLE = "title";
  static const NUMBERCHAPTER = "number_chapter";
  static const DAYRELEASE = "day_release";
  static const CONTENT = "content";
  static const NOVELID = "novel_id";

  late String _id;
  late String _title;
  late int _numberChapter;
  late DateTime _dayRelease;
  late String _content;
  late String _novelId;

//  getters
  String get id => _id;
  String get title => _title;
  int get numberChapter => _numberChapter;
  DateTime get dayRelease => _dayRelease;
  String get content => _content;
  String get novelId => _novelId;

  ChapterModel.fromSnapshot(DocumentSnapshot snapshot) {
    _novelId = snapshot[NOVELID];
    _content = snapshot[CONTENT];
    _dayRelease = snapshot[DAYRELEASE].toDate();
    _numberChapter = snapshot[NUMBERCHAPTER];
    _title = snapshot[TITLE];
    _id = snapshot.id;
  }
}
