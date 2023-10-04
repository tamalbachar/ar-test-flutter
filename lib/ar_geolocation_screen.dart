import 'dart:math';

import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ARGeolocationScreen extends StatefulWidget {
  final double targetLatitude;
  final double targetLongitude;

  ARGeolocationScreen(
      {required this.targetLatitude, required this.targetLongitude});

  @override
  _ARGeolocationScreenState createState() => _ARGeolocationScreenState();
}

class _ARGeolocationScreenState extends State<ARGeolocationScreen> {
  late ArCoreController arController;
  late double userLatitude;
  late double userLongitude;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      userLatitude = position.latitude;
      userLongitude = position.longitude;
    });
  }

  @override
  void dispose() {
    arController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AR Geolocation Example'),
      ),
      body: ArCoreView(onArCoreViewCreated: (controller) {
        arController = controller;
        _loadMarker();
      }),
    );
  }

  void _loadMarker() {
    if (userLatitude != null && userLongitude != null) {
      // Calculate the distance and orientation between user location and target location
      final distance = calculateDistance(userLatitude, userLongitude,
          widget.targetLatitude, widget.targetLongitude);
      final azimuth = calculateAzimuth(userLatitude, userLongitude,
          widget.targetLatitude, widget.targetLongitude);

      // Create and place the AR marker at the calculated distance and orientation
      final arNode = ArCoreNode(
        shape: ArCoreSphere(
          radius: 0.05, // Marker size
          materials: [ArCoreMaterial(color: Colors.blue)],
        ),
        position: vector.Vector3(
          0,
          0,
          -distance, // Negative Z to position the marker in front of the user
        ),
        rotation: vector.Vector4(0, -azimuth, 0, 1),
      );

      arController.addArCoreNode(arNode);
    }
  }

  // Helper function to calculate the distance between two coordinates
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Implement the Haversine formula or use a library like 'geolocator' to calculate distance.
    // This calculation depends on your specific requirements and use case.
    double distanceInMeters =
        Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
    return distanceInMeters;
  }

  // Helper function to calculate the azimuth between two coordinates
  double calculateAzimuth(double lat1, double lon1, double lat2, double lon2) {
    // Implement azimuth calculation logic here.
    // This calculation depends on your specific requirements and use case.
    //return 0.0;
    lat1 = degreesToRadians(lat1);
    lon1 = degreesToRadians(lon1);
    lat2 = degreesToRadians(lat2);
    lon2 = degreesToRadians(lon2);

    // Calculate the difference in longitudes
    double deltaLon = lon2 - lon1;

    // Calculate the azimuth angle
    double azimuth = atan2(
      sin(deltaLon),
      cos(lat1) * tan(lat2) - sin(lat1) * cos(deltaLon),
    );

    // Convert the azimuth from radians to degrees
    azimuth = radiansToDegrees(azimuth);

    // Adjust the azimuth to ensure it's between 0 and 360 degrees
    if (azimuth < 0) {
      azimuth += 360.0;
    }

    return azimuth;
  }

  double degreesToRadians(double degrees) {
    return degrees * (pi / 180.0);
  }

  double radiansToDegrees(double radians) {
    return radians * (180.0 / pi);
  }
}
