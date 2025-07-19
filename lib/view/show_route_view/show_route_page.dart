import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

class LocationTracker extends StatefulWidget {
  final String uid;

  const LocationTracker({Key? key, required this.uid}) : super(key: key);

  @override
  State<LocationTracker> createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  late  DatabaseReference dbRef ;
  // = FirebaseDatabase.instance
  //     .ref()
  //     .child("users")
  //     .child(widget.uid)
  //     .child("location");

  LatLng _currentPosition = const LatLng(28.6139, 77.2090); // Default: Delhi
  LatLng? _targetPosition;

  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  GoogleMapController? _mapController;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    dbRef= FirebaseDatabase.instance
      .ref()
      .child("users")
      .child(widget.uid)
      .child("location");
    _startLocationUpdates();
    _listenToLatestTargetLocation();
  }

  void _startLocationUpdates() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // update only when user moves 10 meters
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      _updatePolylineAndMarker();
    });
  }

  void _listenToLatestTargetLocation() {
    dbRef.orderByKey().limitToLast(1).onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;

      final double lat = data['lat'] * 1.0;
      final double lng = data['long'] * 1.0;

      setState(() {
        _targetPosition = LatLng(lat, lng);
      });

      _updatePolylineAndMarker();
    });
  }

  void _updatePolylineAndMarker() {
    if (_targetPosition == null) return;

    final polyline = Polyline(
      polylineId: const PolylineId("route"),
      color: Colors.blue,
      width: 5,
      points: [_currentPosition, _targetPosition!],
    );

    final targetMarker = Marker(
      markerId: const MarkerId("target"),
      position: _targetPosition!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: "Target Location"),
    );

    setState(() {
      _polylines.clear();
      _polylines.add(polyline);
      _markers.clear();
      _markers.add(targetMarker);
    });

    _moveCameraToBounds();
  }

  void _moveCameraToBounds() {
    if (_mapController == null || _targetPosition == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        _currentPosition.latitude <= _targetPosition!.latitude
            ? _currentPosition.latitude
            : _targetPosition!.latitude,
        _currentPosition.longitude <= _targetPosition!.longitude
            ? _currentPosition.longitude
            : _targetPosition!.longitude,
      ),
      northeast: LatLng(
        _currentPosition.latitude >= _targetPosition!.latitude
            ? _currentPosition.latitude
            : _targetPosition!.latitude,
        _currentPosition.longitude >= _targetPosition!.longitude
            ? _currentPosition.longitude
            : _targetPosition!.longitude,
      ),
    );

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Location Route")),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _currentPosition, zoom: 14),
        myLocationEnabled: true,
        polylines: _polylines,
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }
}
