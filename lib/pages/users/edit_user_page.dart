// ignore_for_file: deprecated_member_use
import 'dart:io' as io;
import 'dart:io';

import 'package:admin_dashboard/helpers/enumerators.dart';
import 'package:admin_dashboard/locator.dart';
import 'package:admin_dashboard/services/navigation_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:admin_dashboard/provider/tables.dart';
import 'package:admin_dashboard/services/user.dart';
import 'package:admin_dashboard/widgets/page_header.dart';

// ignore: must_be_immutable
class EditUserPage extends StatefulWidget {
  Map<String, dynamic> argument;

  EditUserPage({
    Key? key,
    required this.argument,
  }) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

enum SingingCharacter { male, female }
enum statusUpdateAvatar { sucess, fail, failUploadStorage, failUpdateFirestore }

class _EditUserPageState extends State<EditUserPage> {
  final UserServices _userServices = UserServices();
  final FocusNode myFocusNode = FocusNode();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  SingingCharacter? _character;
  PickedFile? _imageFile = PickedFile('');
  final picker = ImagePicker();
  bool _status = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.text = widget.argument['name'];
    _emailController = TextEditingController();
    _emailController.text = widget.argument['email'];
    if (widget.argument['gender'] != 'Null') {
      widget.argument['gender'] == 'male'
          ? (_character = SingingCharacter.male)
          : (_character = SingingCharacter.female);
      debugPrint(widget.argument['gender']);
    }
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!.path != '') {
      setState(() {
        _imageFile = PickedFile(pickedFile.path);
      });
    }
  }

  Future<bool> updatePersonalInformation(
      String id, String name, String gender) async {
    return await _userServices
        .updateUserData(id, {'fullName': name, 'gender': gender});
  }

  Future<bool> updateAvatarFirestore(String id, String avatar) async {
    return await _userServices.updateUserData(id, {'avatar': avatar});
  }

  Future<statusUpdateAvatar> uploadImageToFirebase(String id) async {
    statusUpdateAvatar status = statusUpdateAvatar.fail;
    String fileName = basename(_imageFile!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users')
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
              if (await updateAvatarFirestore(
                  id, await value.ref.getDownloadURL()))
                {status = statusUpdateAvatar.sucess}
              else
                {status = statusUpdateAvatar.failUpdateFirestore}
            })
        .onError((error, stackTrace) => {
              debugPrint("Upload file path error ${error.toString()} "),
              status = statusUpdateAvatar.failUploadStorage
            });
    debugPrint(status.toString());
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final TablesProvider tablesProvider = Provider.of<TablesProvider>(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            text: 'EDIT NOVEL',
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
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Stack(fit: StackFit.loose, children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 150.0,
                                  height: 150.0,
                                  child: CircleAvatar(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: (_imageFile!.path == '')
                                            ? (widget.argument['avatar'] != '')
                                                ? FadeInImage.assetNetwork(
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        'images/loading.gif',
                                                    image: widget
                                                        .argument['avatar'])
                                                : const Image(
                                                    image: AssetImage(
                                                        'images/no_image.jpg'))
                                            : (kIsWeb)
                                                ? Image.network(
                                                    _imageFile!.path)
                                                : Image(
                                                    fit: BoxFit.cover,
                                                    image: FileImage(io.File(
                                                        _imageFile!.path))),
                                      ),
                                    ),
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: pickImage,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 90.0, right: 100.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                        (_imageFile!.path == '')
                            ? const Center()
                            : Container(
                                padding: const EdgeInsets.only(top: 0),
                                child: RaisedButton(
                                  child: const Text("Upload Avatar"),
                                  textColor: Colors.white,
                                  color: Colors.green,
                                  onPressed: () async {
                                    statusUpdateAvatar status =
                                        await uploadImageToFirebase(
                                            widget.argument['id']);
                                    if (status == statusUpdateAvatar.sucess) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Upload Image Succesful!"),
                                        ),
                                      );
                                      tablesProvider
                                          .refreshFromFirebase(Tables.users);
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                        Container(
                          color: const Color(0xffFFFFFF),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const <Widget>[
                                          Text(
                                            'Parsonal Information',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
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
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 70,
                                        child: Text(
                                          'Email: ',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: TextField(
                                              controller: _emailController,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Enter email you want',
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 70,
                                        child: Text(
                                          'Name: ',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: TextField(
                                              controller: _nameController,
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Enter name you want',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const <Widget>[
                                          Text(
                                            'Gender',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Flexible(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: ListTile(
                                                title: const Text('Male'),
                                                leading:
                                                    Radio<SingingCharacter>(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value: SingingCharacter.male,
                                                  groupValue: _character,
                                                  onChanged: (SingingCharacter?
                                                      value) {
                                                    setState(() {
                                                      _character = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListTile(
                                                title: const Text('Female'),
                                                leading:
                                                    Radio<SingingCharacter>(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  value:
                                                      SingingCharacter.female,
                                                  groupValue: _character,
                                                  onChanged: (SingingCharacter?
                                                      value) {
                                                    setState(() {
                                                      _character = value;
                                                    });
                                                  },
                                                  autofocus: !_status,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _getActionButtons(
                            context, widget.argument['id'], tablesProvider)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
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
              // ignore: deprecated_member_use
              child: RaisedButton(
                child: const Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () async {
                  String gender =
                      _character == SingingCharacter.male ? 'male' : 'female';
                  bool status = await updatePersonalInformation(
                      id, _nameController.text, gender);
                  debugPrint(_nameController.text);
                  if (status) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Update Information Succesful!"),
                      ),
                    );
                    tablesProvider.refreshFromFirebase(Tables.users);
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: RaisedButton(
                child: const Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    locator<NavigationService>().goBack();
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
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
