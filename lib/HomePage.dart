import 'package:SafeLink/Pages/FeedPage.dart';
import 'package:SafeLink/Pages/Location.dart';
import 'package:SafeLink/Pages/One_on_One_Chat/ChatRoom.dart';
import 'package:SafeLink/Pages/assistant.dart';
import 'package:SafeLink/Pages/profile.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:background_stt/background_stt.dart';
import 'package:flutter_otp/flutter_otp.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:volume/volume.dart';
import 'main.dart';
import 'package:breathing_collection/breathing_collection.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var bottomPadding = 0.0;
  var call = '';
  var task = '';
  var mode = '';

  Position currentPosition;

  var _service = BackgroundStt();
  var result = '';
  var isListening = false;

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Future<Position> _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  void protocols(String command) async {
    if (code == '' &&
        (command.toLowerCase().contains('help') ||
            command.toLowerCase().contains('call'))) {
      Fluttertoast.showToast(
          msg: "Please Enter the Code",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 13.0);
    } else if (no1 == '' &&
        no2 == '' &&
        no3 == '' &&
        (command.toLowerCase().contains('help') ||
            command.toLowerCase().contains('call'))) {
      Fluttertoast.showToast(
          msg: "Give atleast one contact number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 13.0);
    } else if (command.toLowerCase().contains('help') &&
        command.toLowerCase().contains(code)) {
      setState(() {
        FlutterOtp otp = FlutterOtp();
        if (no1 != '')
          otp.sendOtp(
              no1,
              'https://www.google.com/maps/search/?api=1&query=${currentPosition.latitude.toString()},${currentPosition.longitude.toString()}',
              1000,
              6000,
              '+91');
        if (no2 != '')
          otp.sendOtp(
              no2,
              'https://www.google.com/maps/search/?api=1&query=${currentPosition.latitude.toString()},${currentPosition.longitude.toString()}',
              1000,
              6000,
              '+91');
        if (no3 != '')
          otp.sendOtp(
              no3,
              'https://www.google.com/maps/search/?api=1&query=${currentPosition.latitude.toString()},${currentPosition.longitude.toString()}',
              1000,
              6000,
              '+91');
        bottomPadding = 60;
        call = 'call';
        task = 'message';
        Timer(Duration(seconds: 3), () {
          setState(() {
            bottomPadding = 0;
            call = '';
            task = '';
          });
        });
      });
    } else if (command.toLowerCase().contains('help')) {
      setState(() {
        mode = 'heated';
      });
      Timer(Duration(seconds: 10), () {
        setState(() {
          mode = '';
        });
      });
    } else if (command.toLowerCase().contains('call') &&
        command.toLowerCase().contains(code)) {
      setState(() {
        bottomPadding = 60;
        call = 'call';
        task = 'phone';
        FlutterPhoneDirectCaller.callNumber(no1);
        Timer(Duration(seconds: 3), () {
          setState(() {
            bottomPadding = 0;
            call = '';
            task = '';
          });
        });
      });
    } else if (command.toLowerCase().contains(code)) {
      if (mode == 'heated') {
        setState(() {
          FlutterOtp otp = FlutterOtp();
          if (no1 != '')
            otp.sendOtp(
                no1,
                'https://www.google.com/maps/search/?api=1&query=${currentPosition.latitude.toString()},${currentPosition.longitude.toString()}',
                1000,
                6000,
                '+91');
          if (no2 != '')
            otp.sendOtp(
                no2,
                'https://www.google.com/maps/search/?api=1&query=${currentPosition.latitude.toString()},${currentPosition.longitude.toString()}',
                1000,
                6000,
                '+91');
          if (no3 != '')
            otp.sendOtp(
                no3,
                'https://www.google.com/maps/search/?api=1&query=${currentPosition.latitude.toString()},${currentPosition.longitude.toString()}',
                1000,
                6000,
                '+91');
          bottomPadding = 60;
          call = 'call';
          task = 'message';
          Timer(Duration(seconds: 3), () {
            setState(() {
              bottomPadding = 0;
              call = '';
              task = '';
            });
          });
        });
      }
    }
  }

  var _bottomNavIndex = 0; //default index of first screen
  AnimationController _animationController;
  Animation<double> animation;
  CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.dynamic_feed,
    Icons.chat,
    Icons.location_on,
    FlutterIcons.face_profile_mco,
  ];

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
    final systemTheme = SystemUiOverlayStyle.light.copyWith(
      systemNavigationBarColor: HexColor('ff8664'),
      systemNavigationBarIconBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemTheme);

    _service.startSpeechListenService;
    setState(() {
      if (mounted) isListening = true;
    });

    _service.getSpeechResults().onData((data) {
      protocols(data.result);
      print(data.result);
      setState(() {
        result = data.result;
      });
    });

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    Timer.periodic(Duration(seconds: 20), (timer) {
      _getCurrentLocation();
    });

    Timer.periodic(Duration(seconds: 1), (timer) async {
      await Volume.controlVolume(AudioManager.STREAM_MUSIC);
      await Volume.setVol(15, showVolumeUI: ShowVolumeUI.HIDE);
      await Volume.controlVolume(AudioManager.STREAM_RING);
      await Volume.setVol(15, showVolumeUI: ShowVolumeUI.HIDE);
    });

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          _bottomNavIndex == 0
              ? Feed()
              : _bottomNavIndex == 1
                  ? ChatRoom()
                  : _bottomNavIndex == 2
                      ? location()
                      : _bottomNavIndex == 3
                          ? profile()
                          : Container(
                              color: Colors.pink,
                              child: Text('AN ERROR OCCURRED',
                                  style: TextStyle(fontSize: 18)),
                            ),
          Padding(
            padding: EdgeInsets.only(bottom: h / 7.687),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 10),
                height: call == 'call' ? h / 18.45 : 0,
                width: call == 'call' ? w / 2.4 : 0,
                decoration: BoxDecoration(
                  color: call == 'call' ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (task == 'message')
                      Text(
                        '   sending location...   ',
                        style: TextStyle(
                          fontSize: call == 'call' ? w / 22.5 : 0,
                        ),
                      ),
                    if (task == 'phone')
                      Text(
                        '   calling...   ',
                        style: TextStyle(
                          fontSize: call == 'call' ? w / 22.5 : 0,
                        ),
                      ),
                    Container(
                      height: call == 'call' ? h / 246 : 0,
                      width: call == 'call' ? w / 120 : 0,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: animation,
        child: BreathingGlowingButton(
          icon: Icons.mic_none,
          iconColor: Colors.white,
          buttonBackgroundColor: Colors.pink,
          glowColor: mode == 'heated' ? Color(0xffff8664) : Colors.transparent,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        backgroundColor: HexColor('ff8664'),
        activeIndex: _bottomNavIndex,
        activeColor: HexColor('ff4965'),
        splashColor: HexColor('ff4965'),
        inactiveColor: Colors.white,
        notchAndCornersAnimation: animation,
        splashSpeedInMilliseconds: 300,
        notchSmoothness: NotchSmoothness.defaultEdge,
        gapLocation: GapLocation.center,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  final IconData iconData;

  NavigationScreen(this.iconData) : super();

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void didUpdateWidget(NavigationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.iconData != widget.iconData) {
      _startAnimation();
    }
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    super.initState();
  }

  _startAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: CircularRevealAnimation(
          animation: animation,
          centerOffset: Offset(80, 80),
          maxRadius: MediaQuery.of(context).size.longestSide * 1.1,
          child: Icon(
            widget.iconData,
            color: HexColor('#FFA400'),
            size: 160,
          ),
        ),
      ),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
