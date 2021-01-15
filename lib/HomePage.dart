import 'package:SafeLink/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  @override
  NavBarState createState() => NavBarState();
}

class NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: RaisedButton(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.remove('saferX_email');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyApp()),
            (Route<dynamic> route) => false);
      },
    )));
  }
}
