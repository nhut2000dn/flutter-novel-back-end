// ignore_for_file: deprecated_member_use
import 'dart:io' as io;
import 'dart:io';

import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/locator.dart';
import 'package:admin_dashboard/models/authors.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:admin_dashboard/services/novels.dart';
import 'package:admin_dashboard/widgets/custom_text.dart';
import 'package:admin_dashboard/widgets/loading_opacity.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/services/user.dart';
import 'package:admin_dashboard/widgets/page_header.dart';

// ignore: must_be_immutable
class EditNovelPage extends StatefulWidget {
  Map<String, dynamic> argument;

  EditNovelPage({
    Key? key,
    required this.argument,
  }) : super(key: key);

  @override
  _EditNovelPageState createState() => _EditNovelPageState();
}

enum statusUploadImageAndEditNovel {
  sucess,
  fail,
  failUploadStorage,
  failAddFirestore
}

class _EditNovelPageState extends State<EditNovelPage> {
  final NovelService _novelService = NovelService();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _chapterController;
  late TextEditingController _readerController;
  late TextEditingController _followerController;
  late TextEditingController _yearReleaseController;
  PickedFile? _imageFile = PickedFile('');
  final picker = ImagePicker();
  late bool _isLoading = false;
  late AuthorModel? authorCurrent;
  late bool _statusNovel;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.text = widget.argument['name'];
    _descriptionController = TextEditingController();
    _descriptionController.text = widget.argument['description'];
    _chapterController = TextEditingController();
    _chapterController.text = widget.argument['chapter'].toString();
    _readerController = TextEditingController();
    _readerController.text = widget.argument['reader'].toString();
    _yearReleaseController = TextEditingController();
    _yearReleaseController.text = widget.argument['year_release'].toString();
    _followerController = TextEditingController();
    _followerController.text = widget.argument['follower'].toString();
    _statusNovel = widget.argument['status'];
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!.path != '') {
      setState(() {
        _imageFile = PickedFile(pickedFile.path);
      });
    }
  }

  Future<bool> editNovelToFirebae(
      String id,
      String name,
      String desciption,
      String image,
      bool status,
      int chapter,
      int reader,
      int follower,
      int yearRelease,
      String authorId) async {
    var imageObject = image != '' ? {'image': image} : {};
    return await _novelService.updateNovel(id, {
      ...{
        'name': name,
        'description': desciption,
        'status': status,
        'chapter': chapter,
        'reader': reader,
        'follower': follower,
        'year_release': yearRelease,
        'author_id': authorId
      },
      ...imageObject,
    });
  }

  Future<statusUploadImageAndEditNovel> uploadImageAndEditNovelToFirebase(
      String id,
      String name,
      String desciption,
      bool status,
      int chapter,
      int reader,
      int follower,
      int yearRelease,
      String authorId) async {
    statusUploadImageAndEditNovel statusCheck =
        statusUploadImageAndEditNovel.fail;
    if (_imageFile!.path != '') {
      String fileName = basename(_imageFile!.path);
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('novels')
          .child('/$fileName');

      final metadata = firebase_storage.SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': fileName});
      firebase_storage.UploadTask uploadTask;
      //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageF  ile);
      uploadTask = ref.putData(await _imageFile!.readAsBytes(), metadata);

      firebase_storage.UploadTask task = await Future.value(uploadTask);
      await Future.value(uploadTask)
          .then((value) async => {
                debugPrint(
                    "Upload file path ${await value.ref.getDownloadURL()}"),
                if (await editNovelToFirebae(
                  id,
                  name,
                  desciption,
                  await value.ref.getDownloadURL(),
                  status,
                  chapter,
                  reader,
                  follower,
                  yearRelease,
                  authorId,
                ))
                  {statusCheck = statusUploadImageAndEditNovel.sucess}
                else
                  {statusCheck = statusUploadImageAndEditNovel.failAddFirestore}
              })
          .onError((error, stackTrace) => {
                debugPrint("Upload file path error ${error.toString()} "),
                statusCheck = statusUploadImageAndEditNovel.failUploadStorage
              });
    } else {
      if (await editNovelToFirebae(
        id,
        name,
        desciption,
        '',
        status,
        chapter,
        reader,
        follower,
        yearRelease,
        authorId,
      )) {
        statusCheck = statusUploadImageAndEditNovel.sucess;
      } else {
        statusCheck = statusUploadImageAndEditNovel.failAddFirestore;
      }
    }

    debugPrint(status.toString());
    return statusCheck;
  }

  @override
  Widget build(BuildContext context) {
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    return Stack(
      children: [
        Opacity(
          opacity: _isLoading
              ? 0.5
              : 1, // You can reduce this when loading to give different effect
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PageHeader(
                    text: 'ADD NOVEL',
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
                                              'Name: ',
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
                                                          _nameController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter name novel you want',
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
                                              'Image: ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Stack(
                                              fit: StackFit.loose,
                                              children: <Widget>[
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 150.0,
                                                      height: 150.0,
                                                      child: CircleAvatar(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: AspectRatio(
                                                            aspectRatio: 1,
                                                            child: (_imageFile!
                                                                        .path ==
                                                                    '')
                                                                ? const Image(
                                                                    image: AssetImage(
                                                                        'images/no_image.jpg'))
                                                                : (kIsWeb)
                                                                    ? Image.network(
                                                                        _imageFile!
                                                                            .path)
                                                                    : Image(
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        image: FileImage(
                                                                            io.File(_imageFile!.path))),
                                                          ),
                                                        ),
                                                        foregroundColor:
                                                            Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 150.0,
                                                  height: 150.0,
                                                  child: InkWell(
                                                    onTap: pickImage,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 90.0,
                                                              left: 90),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: const <
                                                            Widget>[
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            radius: 25.0,
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: TextField(
                                                      controller:
                                                          _descriptionController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter Description of novel',
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
                                              'Number of Chapters: ',
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
                                                          _chapterController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter number of chapter',
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
                                              'Reader: ',
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
                                                          _readerController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter number of reader',
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
                                              'Follower: ',
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
                                                          _followerController,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            'Enter number of follower',
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
                                              'Status of Novel: ',
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
                                                    child: DropdownButton(
                                                        isExpanded: true,
                                                        value: _statusNovel,
                                                        items: [
                                                          {
                                                            'lable':
                                                                'Completed',
                                                            'check': true
                                                          },
                                                          {
                                                            'lable':
                                                                'Incomplete',
                                                            'check': false
                                                          }
                                                        ]
                                                            .map(
                                                              (value) =>
                                                                  DropdownMenuItem(
                                                                child: Text(value[
                                                                        'lable']
                                                                    .toString()),
                                                                value: value[
                                                                    'check'],
                                                              ),
                                                            )
                                                            .toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _statusNovel =
                                                                value as bool;
                                                          });
                                                          debugPrint(
                                                              value.toString());
                                                        }),
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
                                              'Year Release: ',
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
                                                          _yearReleaseController,
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
                                              'Author: ',
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
                                                    child: DropdownButton(
                                                        isExpanded: true,
                                                        value: authorCurrent ??
                                                            (authorCurrent =
                                                                tablesProvider
                                                                        .authors[
                                                                    0]),
                                                        items: tablesProvider
                                                            .authors
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
                                                            authorCurrent = value
                                                                as AuthorModel;
                                                          });
                                                          debugPrint(
                                                              value.toString());
                                                        }),
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
            ),
          ),
        ),
        Opacity(
            opacity: _isLoading ? 1.0 : 0,
            child: _isLoading ? const LoadingOpacity() : Container()),
      ],
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
                      setState(() {
                        _isLoading = true;
                      });
                      statusUploadImageAndEditNovel status =
                          await uploadImageAndEditNovelToFirebase(
                        widget.argument['id'],
                        _nameController.text,
                        _descriptionController.text,
                        _statusNovel,
                        int.parse(_chapterController.text),
                        int.parse(_readerController.text),
                        int.parse(_followerController.text),
                        int.parse(_yearReleaseController.text),
                        authorCurrent!.id,
                      );
                      if (status == statusUploadImageAndEditNovel.sucess) {
                        locator<NavigationService>().goBack();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Update Novel Succesful!")));
                        tablesProvider.refreshFromFirebase(Tables.novels);
                      } else if (status ==
                          statusUploadImageAndEditNovel.failUploadStorage) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Upload Image failed!")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Update Novel failed!")));
                      }
                      setState(() {
                        _isLoading = false;
                      });
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
