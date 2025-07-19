import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:seekhelpers_assignment/core/helper/shared_pref_helper.dart';

import '../../core/helper/app_logger.dart';

class ShareLocationPageMapView extends StatefulWidget {
  @override
  _ShareLocationPageMapViewState createState() => _ShareLocationPageMapViewState();
}

class _ShareLocationPageMapViewState extends State<ShareLocationPageMapView> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(28.6139, 77.2090); // default to Delhi
  final databaseRef = FirebaseDatabase.instance.ref("locations/user_123"); // Change user ID as needed

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    // _checkPermission();
    _startUpdatingLocation();
  }

  // Future<void> _checkPermission() async {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     // handle permission denied
  //     return;
  //   }
  // }

  void _startUpdatingLocation() {
    AppLogger.log("started");
    _timer = Timer.periodic(Duration(seconds: 5), (_) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      LatLng newPosition = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentPosition = newPosition;
      });
 String uid = await SharedPrefHelper.getString("uid") ?? "Null";
      final ref = FirebaseDatabase.instance.ref();

      final userLocationRef = ref
          .child('users')
          .child(uid)
          .child('location'); // A new 'locations' child

// Now, use .push() to create a new unique entry under 'locations'
      await userLocationRef.push().set({
        // .push() generates a unique key, then .set() adds the data
        "lat": position.latitude,
        "long": position.longitude,
        "timestamp": DateTime.now().toString()
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    });
  }

Future<void> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    print('Location services are disabled.');
    return;
  }

  // Check permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied.');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied.');
    return;
  }

  // Get current position
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  _currentPosition = LatLng(position.latitude, position.longitude);

  print('Current Location: $_currentPosition');
}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 16,
        ),
        markers: {
          Marker(markerId: MarkerId("me"), position: _currentPosition),
        },
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
      ),
    );
  }
}
