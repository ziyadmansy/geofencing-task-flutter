import 'package:flutter/material.dart';
import 'package:geofencing/providers/location.dart';
import 'package:geofencing/utils/constants.dart';
import 'package:geofencing/widgets/custom_dialogs.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isChecking = false;
  double startLongitude = 0.0;
  double startLatitude = 0.0;

  double endLongitude = 30.23575;
  double endLatitude = 31.0444186;

  double distance = 0.0;

  // Function gets current location after checking on location permisssion
  Future<void> getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    startLongitude = _locationData.longitude;
    startLatitude = _locationData.latitude;
  }

  // function that calculates the distance from current
  // location to work
  Future<void> checkUserLocation() async {
    setState(() {
      _isChecking = true;
    });
    await getCurrentLocation();
    final locData = LocationProvider();
    distance = locData.checkLocationDistance(
      startLongitude,
      startLatitude,
      endLongitude,
      endLatitude,
    );
    if (distance > 50) {
      errorDialog(
        context: context,
        title: 'Sorry',
        body: 'You are not close enough to work',
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
    } else {
      successDialog(
        context: context,
        title: 'Done!',
        body: 'You have checked Your location successfully!',
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
    }
    setState(() {
      _isChecking = false;
    });
  }

  Future<bool> exitApp() async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit App'),
          content: Text('Are you sure that you want to exit the App?'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Geofencing'),
          actions: [
            FlatButton(
              onPressed: () async {
                bool exit = await exitApp();
                if (exit) {
                  Navigator.of(context).pop();
                }
              },
              child: Icon(Icons.exit_to_app_outlined),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Column(
                children: [
                  Text(
                    'Your Work Location',
                    style: TextStyle(
                      fontSize: 24,
                      color: yellowColor,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Latitude: $endLatitude\nLongitude: $endLongitude',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Longitude',
                      labelText: 'Longitude',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        endLongitude = double.tryParse(text) ?? 30.23575;
                      });
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Latitude',
                      labelText: 'Latitude',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        double endLongitude = 30.23575;
                        endLatitude = double.tryParse(text) ?? 31.0444186;
                      });
                    },
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Your Current Location',
                    style: TextStyle(
                      fontSize: 24,
                      color: yellowColor,
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      LocCard(text: startLongitude.toString()),
                      LocCard(text: startLatitude.toString()),
                    ],
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Your Current Distance from Work: ${distance.toStringAsFixed(2)} m',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    child: RaisedButton(
                      child: Text('Check In'),
                      color: greenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                      ),
                      onPressed: _isChecking ? null : checkUserLocation,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 48,
                      child: RaisedButton(
                        child: Text('Check Out'),
                        color: redColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        onPressed: _isChecking ? null : checkUserLocation,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LocCard extends StatelessWidget {
  final String text;

  const LocCard({@required this.text});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
