import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seekhelpers_assignment/core/enums/view_state.dart';
import 'package:seekhelpers_assignment/view/share_location_page/share_location_controller.dart';

class ShareLocationPageMapView extends StatelessWidget {
  const ShareLocationPageMapView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShareLocationController controller = Get.put(ShareLocationController());

    return Scaffold(
      appBar: AppBar(title: const Text("Live Location")),
      body: GetBuilder<ShareLocationController>(
        builder: (controller) {
          if (controller.state == ViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.currentPosition,
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("me"),
                  position: controller.currentPosition,
                ),
              },
              onMapCreated: controller.onMapCreated,
              myLocationEnabled: true,
            );
          }
        },
      ),
    );
  }
}
