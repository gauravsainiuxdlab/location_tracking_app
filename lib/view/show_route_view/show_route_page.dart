import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seekhelpers_assignment/view/show_route_view/show_route_controller.dart';
import 'package:seekhelpers_assignment/core/enums/view_state.dart';

class LocationTracker extends StatelessWidget {
  final String uid;
  const LocationTracker({Key? key, required this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final LocationTrackerController controller =
        Get.put(LocationTrackerController(uid: uid));

    return Scaffold(
      appBar: AppBar(title: const Text("Live Location Route")),
      body: GetBuilder<LocationTrackerController>(
        builder: (controller) {
          if (controller.state == ViewState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (controller.state == ViewState.error) {
            return Center(
              child: Text(
                controller.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: controller.currentPosition, zoom: 14),
              myLocationEnabled: true,
              polylines: controller.polylines,
              markers: controller.markers,
              onMapCreated: controller.onMapCreated,
            );
          }
        },
      ),
    );
  }
}
