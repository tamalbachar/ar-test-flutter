import 'package:flutter/material.dart';
import 'ar_geolocation_screen.dart'; // Import your AR Geolocation screen file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Geolocation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ARGeolocationScreen(
        targetLatitude: 12.9570563, // Specify the target latitude
        targetLongitude: 80.2463393, // Specify the target longitude
      ),
    );
  }
}
