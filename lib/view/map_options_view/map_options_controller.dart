import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/enums/view_state.dart';



/// Controller for managing map state and logic.
/// Extends GetxController to leverage GetX's lifecycle methods and manual updates.
class MapOptionsController extends GetxController {
  // Normal variables for state.
  // Changes to these variables will require an explicit `update()` call
  // to notify GetBuilder widgets.
  GoogleMapController? _googleMapController;
  bool _mapInitialized = false; // Tracks if onMapCreated has been called
  LatLng? _userLocation; // Stores the user's current LatLng

  // State management variables
  ViewState _state = ViewState.loading; // View state
  String _errorMessage = ''; // Error message

  // Public getters to access the private variables from the UI.
  GoogleMapController? get googleMapController => _googleMapController;
  bool get mapInitialized => _mapInitialized;
  LatLng? get userLocation => _userLocation;
  ViewState get state => _state;
  String get errorMessage => _errorMessage;


  // The user ID whose location we want to display.
  final String userId;

  // Stream subscription to manage the Firestore listener.
  StreamSubscription<QuerySnapshot>? _locationSubscription;

  /// Constructor for the MapOptionsController.
  /// Requires a userId to filter location data from Firestore.
  MapOptionsController({required this.userId});

  /// Called when the controller is initialized.
  /// This is where we set up our Firestore listener.
  @override
  void onInit() {
    super.onInit();
    listenToUserLocation();
  }

  /// Called when the controller is closed (disposed).
  /// This is where we clean up resources, like cancelling the Firestore subscription
  /// and disposing the GoogleMapController.
  @override
  void onClose() {
    _locationSubscription?.cancel(); // Cancel Firestore listener
    _googleMapController?.dispose(); // Dispose the map controller
    super.onClose();
  }

  /// Callback method for GoogleMap's onMapCreated.
  /// Stores the controller and updates the mapInitialized flag.
  /// If user location is already available, it animates the camera.
  void onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    _mapInitialized = true; // Mark map as ready
    update(); // Notify GetBuilder that state has changed

    // If we already have a user location and the map is initialized,
    // animate the camera. This handles cases where location data arrives
    // before the map is fully created.
    if (_userLocation != null && _state == ViewState.complete) {
      _animateCameraToUserLocation();
    }
  }

  /// Sets up a real-time listener to the 'location' collection in Firestore.
  /// It filters for the document matching the `userId` and updates `userLocation`.
  void listenToUserLocation() {
    _state = ViewState.loading; // Set state to loading before fetching
    update(); // Explicitly update UI

    _locationSubscription = FirebaseFirestore.instance
        .collection('location')
        .snapshots() // Listen for real-time updates
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        try {
          // Find the specific user's document by its ID.
          final userDoc = snapshot.docs.singleWhere(
            (element) => element.id == userId,
            orElse: () => throw Exception("User document not found for ID: $userId"),
          );

          // Extract latitude and longitude.
          final double latitude = userDoc['latitude'];
          final double longitude = userDoc['longitude'];

          // Update the userLocation.
          _userLocation = LatLng(latitude, longitude);
          _state = ViewState.complete; // Data successfully fetched and parsed
          _errorMessage = ''; // Clear any previous error message
          update(); // Explicitly update UI

          // If the map is ready and we have a new location, animate the camera.
          if (_mapInitialized && _googleMapController != null) {
            _animateCameraToUserLocation();
          }
        } catch (e) {
          // Handle cases where the user document might not exist or data is malformed.
          print("Error finding user location or parsing data: $e");
          _errorMessage = "Failed to load user location: ${e.toString()}";
          _state = ViewState.error; // Set state to error
          _userLocation = null; // Clear location if an error occurs
          update(); // Explicitly update UI
        }
      } else {
        // Handle case where the 'location' collection is empty.
        print("Firestore 'location' collection is empty.");
        _errorMessage = "No location data available in Firestore.";
        _state = ViewState.empty; // Set state to empty
        _userLocation = null;
        update(); // Explicitly update UI
      }
    }, onError: (error) {
      // Handle any errors from the Firestore stream itself.
      print("Error listening to Firestore location stream: $error");
      _errorMessage = "Network or Firestore error: ${error.toString()}";
      _state = ViewState.error; // Set state to error
      _userLocation = null;
      update(); // Explicitly update UI
    });
  }

  /// Animates the Google Map camera to the current user's location.
  /// Only performs animation if the map controller and user location are available.
  Future<void> _animateCameraToUserLocation() async {
    if (_googleMapController != null && _userLocation != null) {
      await _googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _userLocation!,
            zoom: 14.47, // Keep the same zoom level
          ),
        ),
      );
    }
  }

  /// Getter for the set of markers to display on the map.
  /// Returns an empty set if userLocation is null, otherwise returns a single marker.
  Set<Marker> get markers {
    if (_userLocation == null) {
      return {};
    }
    return {
      Marker(
        position: _userLocation!,
        markerId: const MarkerId('user_location_marker'), // Use a constant MarkerId
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ),
    };
  }

  /// Getter for the initial camera position of the map.
  /// Provides a default position (0,0) if userLocation is not yet available.
  /// The camera will be animated to the actual user location once data arrives.
  CameraPosition get initialCameraPosition {
    return CameraPosition(
      target: _userLocation ?? LatLng(0, 0), // Default to (0,0) if no location yet
      zoom: 14.47,
    );
  }
}
