import 'package:flutter/material.dart';
import 'package:geofencing/providers/location.dart';
import 'package:geofencing/screens/home_page.dart';

void main() {
  runApp(GeofencingApp());
}

class GeofencingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark(),
        home: HomePage(),
      );
  }
}
