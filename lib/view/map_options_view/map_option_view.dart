import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/enums/view_state.dart';
import 'map_options_controller.dart'; 

/// MapsOptionsView is a StatelessWidget that displays a Google Map.
/// It uses a GetX controller (MapOptionsController) to manage its state and logic.
class MapsOptionsView extends StatelessWidget {
  final String userId;

  /// Constructor for MapsOptionsView.
  /// It takes a userId to identify which user's location to display.
  MapsOptionsView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize and put the MapOptionsController into GetX's dependency injection system.
    // Get.put() creates the controller if it doesn't exist and registers it.
    final MapOptionsController controller = Get.put(MapOptionsController(userId: userId));

    return Scaffold(
      // GetBuilder listens for `update()` calls from the controller.
      body: GetBuilder<MapOptionsController>(
        builder: (controller) {
          // The UI logic remains similar, but now accesses properties directly
          // without the `.value` suffix for Rx variables.
          switch (controller.state) { // Accessing `state` directly
            case ViewState.loading:
              return const Center(child: CircularProgressIndicator());
            case ViewState.empty:
              return Center(
                child: Text(
                  controller.errorMessage.isNotEmpty // Accessing `errorMessage` directly
                      ? controller.errorMessage
                      : 'No location data found for this user.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            case ViewState.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      const SizedBox(height: 10),
                      Text(
                        controller.errorMessage.isNotEmpty
                            ? controller.errorMessage
                            : 'An unknown error occurred.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => controller.listenToUserLocation(), // Re-attempt fetch
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            case ViewState.complete:
              // Ensure mapInitialized and userLocation are not null before displaying the map
              if (!controller.mapInitialized || controller.userLocation == null) { // Accessing directly
                return const Center(child: CircularProgressIndicator());
              }
              return GoogleMap(
                mapType: MapType.normal,
                markers: controller.markers,
                initialCameraPosition: controller.initialCameraPosition,
                onMapCreated: controller.onMapCreated,
              );
            default:
              return const Center(child: Text('Unknown State'));
          }
        },
      ),
    );
  }
}
