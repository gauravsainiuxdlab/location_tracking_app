import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seekhelpers_assignment/view/show_route_view/show_route_controller.dart';

class LocationTracker extends StatelessWidget {
  final String uid;

  const LocationTracker({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller here. Get.put will create a new instance
    // for this route and it will be automatically disposed when the route is removed.
    final LocationTrackerController controller =
        Get.put(LocationTrackerController(uid: uid));

    return Scaffold(
      appBar: AppBar(title: const Text("Live Location Route")),
      body: GetBuilder<LocationTrackerController>(
        builder: (controller) {
          return GoogleMap(
            initialCameraPosition:
                CameraPosition(target: controller.currentPosition, zoom: 14),
            myLocationEnabled: true,
            polylines: controller.polylines,
            markers: controller.markers,
            onMapCreated: controller.onMapCreated,
          );
        },
      ),
    );
  }
}
