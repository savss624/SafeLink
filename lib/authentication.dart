import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Pages/One_on_One_Chat/database1.dart';

String email = '';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  String password = '';
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);
  Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.pink,
        cursorColor: Colors.pink,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              height: h / 1.2,
              width: w,
              child: RotatedBox(
                quarterTurns: 0,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: w / 4, left: w / 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Welcome ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: 'Fredoka One',
                    ),
                  ),
                  Text(
                    "Back ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: 'Fredoka One',
                    ),
                  ),
                ],
              ),
            ),
            FlutterLogin(
              title: "",
              emailValidator: (value) {
                if (!value.contains('@') || !value.endsWith('.com')) {
                  return "Email must contain '@' and end with '.com'";
                }
                return null;
              },
              passwordValidator: (value) {
                if (value.isEmpty || value.length < 6) {
                  return 'Password is empty';
                }
                return null;
              },
              onLogin: (loginData) async {
                email = loginData.name;
                password = loginData.password;
                try {
                  UserCredential newUser = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove('SafeLink_email');
                  prefs.setString('SafeLink_email', email.toString());
                  Fluttertoast.showToast(
                      msg: "Logging In",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 13.0);
                  // Navigator.of(context).pushAndRemoveUntil(
                  //     MaterialPageRoute(builder: (context) => NavBar()),
                  //     (Route<dynamic> route) => false);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NavBar()));
                } catch (e) {
                  print(e);
                }
                return _loginUser(loginData);
              },
              onSignup: (loginData) async {
                email = loginData.name;
                password = loginData.password;
                try {
                  final newUser = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  Map<String, String> userDataMap = {
                    "userName":
                        loginData.name.substring(0, loginData.name.length - 10),
                    "userEmail": loginData.name,
                  };
                   DatabaseMethods databaseMethods = new DatabaseMethods();
                   databaseMethods.addUserInfo(userDataMap);
                  Fluttertoast.showToast(
                      msg: "Registered",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 13.0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Authentication()));
                } catch (e) {
                  print(e);
                }
                return _loginUser(loginData);
              },
              onRecoverPassword: (email) {
                //reset pw of email
                return _recoverPassword(email);
              },
            ),
          ],
        ),
      ),
    );
  }
}
