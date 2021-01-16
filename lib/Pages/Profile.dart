import 'dart:async';
import 'package:SafeLink/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:saferx/Aboutdevs.dart';
//import 'package:SafeLink/lib/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../authentication.dart';
import 'assistant.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

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
  final RoundedLoadingButtonController _roundedLoadingButtonController = new RoundedLoadingButtonController();
  String _code = code;
  String _name1 = name1;
  String _no1 = no1;
  String _name2 = name2;
  String _no2 = no2;
  String _name3 = name3;
  String _no3 = no3;

  @override
  Widget build(BuildContext context) {

    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.green[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
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
                  height: h/36.9,
                ),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18))
                  ),
                  child: Container(
                    width: w/1.14,
                    //height: 200,
                    child: Padding(
                      padding: EdgeInsets.all(w/22.5),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Important Info.',
                                style: TextStyle(
                                    color: Color(0xffff8664),
                                    fontSize: w/20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            SizedBox(height: h/92.25),
                            Center(
                              child: Text(
                                'Code to trigger help me',
                                style: TextStyle(
                                    color: Color(0xffff8664),
                                    fontSize: w/20
                                ),
                              ),
                            ),
                            SizedBox(height: h/92.25),
                            Center(
                              child: Container(
                                width: w/1.33,
                                height: h/12.3,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xffff8664), width: 2, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.all(Radius.circular(18))
                                ),
                                child: Center(
                                  child: Container(
                                    width: w/1.5,
                                    child: TextFormField(
                                      initialValue: code,
                                      cursorColor: Color(0xffff8664),
                                      decoration: InputDecoration(
                                          labelText: 'Code',
                                          border: InputBorder.none
                                      ),
                                      onChanged: (String value) {
                                        _code = value;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: h/123),
                            Text(
                                '1st Guardian',
                                style: TextStyle(
                                  color: Color(0xffff8664),
                                  fontSize: w/20
                                ),
                            ),
                            SizedBox(height: h/369),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: w/2.77,
                                  height: h/12.3,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xffff8664), width: 2, style: BorderStyle.solid),
                                    borderRadius: BorderRadius.all(Radius.circular(18))
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: w/3.6,
                                      child: TextFormField(
                                        initialValue: name1,
                                        cursorColor: Color(0xffff8664),
                                        decoration: InputDecoration(
                                          labelText: 'Name',
                                          border: InputBorder.none
                                        ),
                                        onChanged: (String value) {
                                          _name1 = value;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: w/18,
                                ),
                                Container(
                                  width: w/2.77,
                                  height: h/12.3,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xffff8664), width: 2, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(Radius.circular(18))
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: w/3.6,
                                      child: TextFormField(
                                        initialValue: no1,
                                        cursorColor: Color(0xffff8664),
                                        decoration: InputDecoration(
                                            labelText: 'Contact No.',
                                            border: InputBorder.none
                                        ),
                                        onChanged: (String value) {
                                          _no1 = value;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: h/369),
                            Text(
                              '2nd Guardian',
                              style: TextStyle(
                                  color: Color(0xffff8664),
                                  fontSize: w/20
                              ),
                            ),
                            SizedBox(height: h/369),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: w/2.77,
                                  height: h/12.3,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xffff8664), width: 2, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(Radius.circular(18))
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: w/3.6,
                                      child: TextFormField(
                                        initialValue: name2,
                                        cursorColor: Color(0xffff8664),
                                        decoration: InputDecoration(
                                            labelText: 'Name',
                                            border: InputBorder.none
                                        ),
                                        onChanged: (String value) {
                                          _name2 = value;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: w/18,
                                ),
                                Container(
                                  width: w/2.77,
                                  height: h/12.3,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xffff8664), width: 2, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(Radius.circular(18))
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: w/3.6,
                                      child: TextFormField(
                                        cursorColor: Color(0xffff8664),
                                        initialValue: no2,
                                        decoration: InputDecoration(
                                            labelText: 'Contact No.',
                                            border: InputBorder.none
                                        ),
                                        onChanged: (String value) {
                                          _no2 = value;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: h/369),
                            Text(
                              '3rd Guardian',
                              style: TextStyle(
                                  color: Color(0xffff8664),
                                  fontSize: w/20
                              ),
                            ),
                            SizedBox(height: h/369),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: w/2.77,
                                  height: h/12.3,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xffff8664), width: 2, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(Radius.circular(18))
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: w/3.6,
                                      child: TextFormField(
                                        initialValue: name3,
                                        cursorColor: Color(0xffff8664),
                                        decoration: InputDecoration(
                                            labelText: 'Name',
                                            border: InputBorder.none
                                        ),
                                        onChanged: (String value) {
                                          _name3 = value;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: w/18,
                                ),
                                Container(
                                  width: w/2.77,
                                  height: h/12.3,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xffff8664), width: 2, style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(Radius.circular(18))
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: w/3.6,
                                      child: TextFormField(
                                        cursorColor: Color(0xffff8664),
                                        initialValue: no3,
                                        decoration: InputDecoration(
                                            labelText: 'Contact No.',
                                            border: InputBorder.none
                                        ),
                                        onChanged: (String value) {
                                          _no3 = value;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: h/46.125),
                            Center(
                              child: Container(
                                width: w*.4,
                                height: h*.05,
                                child: RoundedLoadingButton(
                                  controller: _roundedLoadingButtonController,
                                  onPressed: () async {
                                    Timer(Duration(seconds: 5), () {
                                      _roundedLoadingButtonController.success();
                                      _roundedLoadingButtonController.reset();
                                      Fluttertoast.showToast(
                                          msg: "Saved",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black54,
                                          textColor: Colors.white,
                                          fontSize: 13.0);
                                    });
                                    final prefs = await SharedPreferences.getInstance();
                                    prefs.setString('code', _code);
                                    prefs.setString('name1', _name1);
                                    prefs.setString('no1', _no1);
                                    prefs.setString('name2', _name2);
                                    prefs.setString('no2', _no2);
                                    prefs.setString('name3', _name3);
                                    prefs.setString('no3', _no3);
                                    code = _code;
                                    name1 = _name1;
                                    no1 = _no1;
                                    name2 = _name2;
                                    no2 = _no2;
                                    name3 = _name3;
                                    no3 = _no3;
                                  },
                                  successColor: Color(0xffff8664),
                                  valueColor: Color(0xfffef8fa),
                                  color: Color(0xffff8664),
                                  child: Container(
                                    width: w*.4,
                                    height: h*.05,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xffff8664), Color(0xffff4965)],
                                      ),
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            fontFamily: 'Overpass',
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xfffef8fa),
                                            fontSize: w*.04
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h/7.38),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
