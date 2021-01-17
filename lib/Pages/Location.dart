import 'package:SafeLink/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flare_flutter/flare_actor.dart';

class location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<location> {
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress;
  String _curr;

  Future<Position> _getCurrentLocation() async {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress = "${place.locality}-${place.administrativeArea}";
        _curr = "${place.administrativeArea}".toLowerCase();
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _showAlertDialog(BuildContext context, String message, Color color) {
    AlertDialog alert = AlertDialog(
      title: Text(
        "SafeLink Report",
        style: TextStyle(color: HexColor('ff4965'), fontSize: 20.0),
      ),
      content: Text(message, style: TextStyle(color: color)),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text("OK",
              style: TextStyle(fontSize: 20.0, color: HexColor('ff8864'))),
        ),
      ],
      elevation: 10,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.green[100],
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(15))),
              backgroundColor: HexColor('ff8864'),
              expandedHeight: MediaQuery.of(context).size.height / 3,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(_currentAddress,
                    style: TextStyle(color: Colors.black, letterSpacing: 2)),
                background: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(_currentPosition.latitude,
                            _currentPosition.longitude),
                        zoom: 16.0),
                    zoomGesturesEnabled: true,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RaisedButton(
                          textColor: Colors.white,
                          child: Text('Check Safety'),
                          elevation: 5,
                          padding: EdgeInsets.all(20),
                          color: HexColor('#ff4965'),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                          onPressed: () {
                            List<double> a = [
                              2.9,
                              0.1,
                              2.4,
                              5.2,
                              1.9,
                              5.2,
                              0.1,
                              7.7,
                              3.8,
                              0.4,
                              0.5,
                              1.1,
                              3.2,
                              10.1,
                              8,
                              10.2,
                              0.1,
                              0.1,
                              0,
                              0,
                              2.1,
                              1.4,
                              4.9,
                              0,
                              9.8,
                              2.5,
                              0.1,
                              11.5,
                              0.7,
                              3.7
                            ];
                            List<String> b = [
                              'andhra pradesh',
                              'arunachal pradesh',
                              'assam',
                              'bihar',
                              'chhattisgarh',
                              'delhi',
                              'goa',
                              'gujarat',
                              'haryana',
                              'himachal pradesh',
                              'jammu and kashmir',
                              'jharkhand',
                              'karnataka',
                              'kerala',
                              'madhya pradesh',
                              'maharashtra',
                              'manipur',
                              'meghalaya',
                              'mizoram',
                              'nagaland',
                              'odisha',
                              'punjab',
                              'rajasthan',
                              'sikkim',
                              'tamil nadu',
                              'telangana',
                              'tripura',
                              'uttar pradesh',
                              'uttarakhand',
                              'west bengal'
                            ];
                            int i = 0;
                            for (; i < 31; i++) {
                              if (_curr == b[i]) break;
                            }
                            if (a[i] >= 6) {
                              _showAlertDialog(
                                  context,
                                  'The place that you are in right now is not at all SAFE due to high CRIME RATE against Women as per our Research Data. Stay Safe and if help is needed just say \'Help Me\'. \nCRIME RATE in your City - ' +
                                      a[i].toString() +
                                      '%',
                                  Colors.red);
                            } else if (a[i] >= 3) {
                              _showAlertDialog(
                                  context,
                                  'The place that you are in right now is moderately SAFE with average CRIME RATE against Women as per our Research Data. Stay Safe and if help is needed just say \'Help Me\'. \nCRIME RATE in your City - ' +
                                      a[i].toString() +
                                      '%',
                                  Colors.orange);
                            } else {
                              _showAlertDialog(
                                  context,
                                  'The place that you are in right now is normally SAFE with very low CRIME RATE against Women as per our Research Data. Still Stay Safe and if help is needed just say \'Help Me\'. \nCRIME RATE in your City -' +
                                      a[i].toString() +
                                      '%',
                                  Colors.green);
                            }
                          },
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
    );
  }
}
