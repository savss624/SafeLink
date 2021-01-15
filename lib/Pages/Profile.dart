import 'package:SafeLink/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: RaisedButton(
      child: Text('Logout'),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('SafeLink_email');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyApp()),
            (Route<dynamic> route) => false);
      },
    )));
  }
}
