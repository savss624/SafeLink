import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:saferx/Aboutdevs.dart';
//import 'package:SafeLink/lib/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../authentication.dart';
import 'assistant.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  File _image;
  final picker = ImagePicker();
  String CircleAvtarLink = null;
  CollectionReference UserRefrance =
  FirebaseFirestore.instance.collection('ProfilePicUrl');

  Future<void> AddToFirestore(var url) {
    return UserRefrance.doc(email.substring(0, email.indexOf('@')))
        .set({
      'URL': url,
    })
        .then((value) => print('user added'))
        .catchError((error) => print('Failed to add User'));
  }

  Future<StorageUploadTask> uploadFile(BuildContext context) async {
    String fileName = path.basename(_image.path);
    StorageReference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(email.substring(0, email.indexOf('@')))
        .child(fileName);
    StorageUploadTask uploadTask = ref.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    final url1 = await taskSnapshot.ref.getDownloadURL();
    //print(url1.toString());
    setState(() {
      CircleAvtarLink = url1.toString();
      AddToFirestore(url1);
    });
  }

  Future<void> getImageViaGallery() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper.cropImage(
        sourcePath: File(pickedFile.path).path,
      );
      setState(() {
        if (croppedFile != null) {
          _image = File(croppedFile.path);
          uploadFile(context);
        } else {
          print('No file selected');
        }
      });
    }
  }

  Future<void> getImageViaCamera() async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper.cropImage(
        sourcePath: File(pickedFile.path).path,
      );
      setState(() {
        if (croppedFile != null) {
          _image = File(croppedFile.path);
          uploadFile(context);
        } else {
          print('No file selected');
        }
      });
    } else {
      print('No file selected');
    }
  }

  String setImage() {
    String mainLink = null;
    UserRefrance.doc(email.substring(0, email.indexOf('@')))
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        var link = documentSnapshot.data()['URL'];
        print(link);
        setState(() {
          CircleAvtarLink = link.toString();
        });
        //  CircleAvtarImage=link.toString();
        print(CircleAvtarLink);
      } else {
        print('unsucsessful');
      }
    });
  }

  void displayBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 150,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                    onTap: getImageViaCamera,
                  ),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: Text('Gallery'),
                    onTap: getImageViaGallery,
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    setImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    resizeToAvoidBottomInset:
    true;
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 2 - 75,
                            30,
                            115,
                            30),
                        child: CircleAvatar(
                          radius: 75.0,
                          backgroundImage: CircleAvtarLink == null
                              ? AssetImage('images/profile.png')
                              : NetworkImage(CircleAvtarLink),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width / 2 + 20,
                            130,
                            115,
                            30),
                        child: ButtonTheme(
                          buttonColor: Colors.purple,
                          minWidth: 20,
                          height: 40,
                          child: RaisedButton(
                            onPressed: displayBottomSheet,
                            child: Icon(Icons.camera_alt_outlined),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(100)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      color: Colors.purple,
                      child: Container(
                          height: 30,
                          width: 60,
                          child: Center(
                              child: Text('LOGOUT',
                                  style: TextStyle(fontSize: 15)))),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove('saferX_email');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Authentication()));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Text('First Number'),
                // TextFormField(
                //     initialValue: first,
                //     keyboardType: TextInputType.number,
                //     onChanged: (String value) async {
                //       final prefs = await SharedPreferences.getInstance();
                //       prefs.setString('first_number', value);
                //     }),
                SizedBox(
                  height: 20,
                ),
                Text('Second Number'),
                // TextFormField(
                //     initialValue: second,
                //     keyboardType: TextInputType.number,
                //     onChanged: (String value) async {
                //       final prefs = await SharedPreferences.getInstance();
                //       prefs.setString('second_number', value);
                //     }),
                SizedBox(
                  height: 20,
                ),
                Text('Third Number'),
                // TextFormField(
                //     initialValue: third,
                //     keyboardType: TextInputType.number,
                //     onChanged: (String value) async {
                //       final prefs = await SharedPreferences.getInstance();
                //       prefs.setString('third_number', value);
                //     }),
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: RaisedButton(
                //       color: Colors.purple,
                //       child: Container(
                //           height: 30,
                //           width: 50,
                //           child: Center(
                //               child: Text('About',
                //                   style: TextStyle(fontSize: 15)))),
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => AboutDev()));
                //       },
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(10)),
                //       )),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
