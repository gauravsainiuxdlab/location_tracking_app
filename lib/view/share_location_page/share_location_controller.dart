import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seekhelpers_assignment/core/enums/view_state.dart';
import 'package:seekhelpers_assignment/core/helper/shared_pref_helper.dart';
import '../../core/helper/app_logger.dart';

class ShareLocationController extends GetxController {
  GoogleMapController? mapController;
  LatLng currentPosition = const LatLng(28.6139, 77.2090); // Default to Delhi
  ViewState state = ViewState.complete;
  StreamSubscription<Position>? _positionStream;

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

 void onMapCreated(GoogleMapController controller) async {
  mapController = controller;

  // Animate camera to current location
  await mapController?.animateCamera(CameraUpdate.newLatLng(currentPosition));

  // Only now mark it complete
  
}


  Future<void> _initializeLocation() async {
    try {
       state = ViewState.loading;
      update();
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Error", "Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Error", "Location permissions are denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar("Error", "Location permissions are permanently denied.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition = LatLng(position.latitude, position.longitude);
      update();

      // Move map camera immediately if map is already initialized
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition, 16),
      );
       state = ViewState.complete;
      update();
      _startLocationStream();
    } catch (e, stackTrace) {
      AppLogger.log("Error initializing location: $e");
      AppLogger.log(stackTrace.toString());
      state = ViewState.error;
      update();
      Get.snackbar("Error", "Failed to get current location.");
    }
  }




  void _startLocationStream() {
    try {
      _positionStream?.cancel();

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      Get.snackbar("Info", "Location sharing started...");

      _positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) async {
          try {
            currentPosition = LatLng(position.latitude, position.longitude);

            await _updateLocationInFirebase(position);

            mapController?.animateCamera(
              CameraUpdate.newLatLng(currentPosition),
            );
          } catch (e, stackTrace) {
            AppLogger.log('Error in position stream callback: $e');
            AppLogger.log(stackTrace.toString());

            Get.snackbar("Error", "Failed to update location or map.");
            update();
          }
        },
        onError: (error) {
          AppLogger.log('Stream error: $error');
          state = ViewState.error;
          Get.snackbar("Error", "Error while listening to location stream.");
          update();
        },
      );

      state = ViewState.complete;
      update();
    } catch (e, stackTrace) {
      AppLogger.log('Error starting location stream: $e');
      AppLogger.log(stackTrace.toString());
      state = ViewState.error;
      Get.snackbar("Error", "Failed to start location stream.");
      update();
    }
  }

  Future<void> _updateLocationInFirebase(Position position) async {
    String uid = await SharedPrefHelper.getString("uid") ?? "Null";
    if (uid == "Null") return;

    final userLocationRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(uid)
        .child('location');

    await userLocationRef.push().set({
      "lat": position.latitude,
      "long": position.longitude,
      "timestamp": DateTime.now().toIso8601String(),
    });
  }

  @override
  void onClose() {
    _positionStream?.cancel();
    super.onClose();
  }
}
