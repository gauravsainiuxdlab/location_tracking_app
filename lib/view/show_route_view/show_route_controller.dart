import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seekhelpers_assignment/core/enums/view_state.dart';
import '../../core/helper/app_logger.dart';

class LocationTrackerController extends GetxController {
  final String uid;
  LocationTrackerController({required this.uid});

  ViewState state = ViewState.complete;
  String errorMessage = "";

  late DatabaseReference dbRef;
  LatLng currentPosition = const LatLng(28.6139, 77.2090); // Default: Delhi
  LatLng? targetPosition;

  final Set<Polyline> polylines = {};
  final Set<Marker> markers = {};
  GoogleMapController? mapController;

  StreamSubscription<Position>? _positionStream;
  StreamSubscription? _targetLocationStream;

  // Flags to ensure both location and target are initialized before setting state = complete
  bool _isLocationInitialized = false;
  bool _isTargetLocationInitialized = false;

  @override
  void onInit() {
    super.onInit();
    dbRef = FirebaseDatabase.instance.ref().child("users").child(uid).child("location");
    _startLocationUpdates();
    _listenToLatestTargetLocation();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _startLocationUpdates() async {
    try {
      state = ViewState.loading;
      update();

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        state = ViewState.error;
        errorMessage = 'Location permission denied.';
        update();
        return;
      }

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // update only when user moves 10 meters
      );

      _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position position) {
        currentPosition = LatLng(position.latitude, position.longitude);
        _isLocationInitialized = true;
        _checkIfReadyToComplete();
        _updatePolylineAndMarker();
      });
    } catch (e, stackTrace) {
      AppLogger.log('Error in _startLocationUpdates: $e');
      AppLogger.log(stackTrace.toString());
      state = ViewState.error;
      errorMessage = 'Failed to start location updates.';
      update();
    }
  }

  void _listenToLatestTargetLocation() {
    _targetLocationStream = dbRef.orderByKey().limitToLast(1).onChildAdded.listen((event) {
      if (event.snapshot.value == null) return;
      try {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final double lat = data['lat'] * 1.0;
        final double lng = data['long'] * 1.0;

        targetPosition = LatLng(lat, lng);
        _isTargetLocationInitialized = true;
        _checkIfReadyToComplete();
        _updatePolylineAndMarker();
      } catch (e) {
        AppLogger.log("Error parsing target location: $e");
      }
    });
  }

  void _checkIfReadyToComplete() {
    if (_isLocationInitialized && _isTargetLocationInitialized) {
      state = ViewState.complete;
      update();
    }
  }

  void _updatePolylineAndMarker() {
    if (targetPosition == null) return;

    final polyline = Polyline(
      polylineId: const PolylineId("route"),
      color: Colors.blue,
      width: 5,
      points: [currentPosition, targetPosition!],
    );

    final targetMarker = Marker(
      markerId: const MarkerId("target"),
      position: targetPosition!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: const InfoWindow(title: "Target Location"),
    );

    polylines.clear();
    polylines.add(polyline);
    markers.clear();
    markers.add(targetMarker);

    _moveCameraToBounds();
    update();
  }

  void _moveCameraToBounds() {
    if (mapController == null || targetPosition == null) return;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        currentPosition.latitude <= targetPosition!.latitude
            ? currentPosition.latitude
            : targetPosition!.latitude,
        currentPosition.longitude <= targetPosition!.longitude
            ? currentPosition.longitude
            : targetPosition!.longitude,
      ),
      northeast: LatLng(
        currentPosition.latitude >= targetPosition!.latitude
            ? currentPosition.latitude
            : targetPosition!.latitude,
        currentPosition.longitude >= targetPosition!.longitude
            ? currentPosition.longitude
            : targetPosition!.longitude,
      ),
    );

    mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    _targetLocationStream?.cancel();
    super.onClose();
  }
}
