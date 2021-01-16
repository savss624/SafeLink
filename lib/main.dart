import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

String code ='';
String name1 = '';
String no1 = '';
String name2 = '';
String no2 = '';
String name3 = '';
String no3 = '';

Future main() async {
  RenderErrorBox.backgroundColor = Colors.white;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.white);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var status = prefs.getString('SafeLink_email');
  code = prefs.getString('code');
  name1 = prefs.getString('name1');
  no1 = prefs.getString('no1');
  name2 = prefs.getString('name2');
  no2 = prefs.getString('no2');
  name3 = prefs.getString('name3');
  no3 = prefs.getString('no3');
  if (status != null) {
    email = status.toString();
  }
  final systemTheme = SystemUiOverlayStyle.light.copyWith(
    systemNavigationBarColor: Colors.pink,
    systemNavigationBarIconBrightness: Brightness.light,
  );
  SystemChrome.setSystemUIOverlayStyle(systemTheme);
  runApp(MyApp(status: status));
}

class MyApp extends StatelessWidget {
  var status;
  MyApp({this.status});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: status == null ? Authentication() : NavBar());
  }
}
