import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekhelpers_assignment/core/enums/view_state.dart';
import 'package:seekhelpers_assignment/view/home_page/home_page_controller.dart';
import 'package:seekhelpers_assignment/view/share_location_page/share_location_page_view.dart';
import 'package:seekhelpers_assignment/view/show_route_view/show_route_page.dart' show LocationTracker;

import '../../core/constants/color_constants.dart';
import '../../core/helper/app_logger.dart';

class HomePage extends StatelessWidget {
  final HomePageController controller = Get.put(HomePageController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ShareLocationPageMapView());
        },
        child: const Icon(Icons.location_on),
      ),
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: ColorConstants.primary,
      ),
      body: GetBuilder<HomePageController>(
        builder: (controller) {
          switch (controller.state) {
            case ViewState.loading:
              return const Center(child: CircularProgressIndicator());

            case ViewState.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(controller.errorMessage),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: controller.fetchUsers,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );

            case ViewState.empty:
              return const Center(child: Text("No users available"));

            case ViewState.complete:
              return Column(
                children: [
                  Text("Id: ${controller.uid}"),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (_) => controller.update(),
                      controller: controller.searchController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Search...",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('users').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(child: Text("No users found"));
                        }

                        final allUsers = snapshot.data!.docs
                            .map((doc) => doc.data() as Map<String, dynamic>)
                            .where((user) => user["uid"] != controller.uid)
                            .toList();

                        final query = controller.searchController.text.trim().toLowerCase();
                        final filteredUsers = query.isEmpty
                            ? allUsers
                            : allUsers.where((user) =>
                                (user["uid"] as String).toLowerCase().contains(query)).toList();

                        AppLogger.log("Filtered users: $filteredUsers");

                        return ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              elevation: 2,
                              child: ListTile(
                                onTap: () {
                                  Get.to(LocationTracker(uid: user["uid"]));
                                },
                                leading: CircleAvatar(
                                  backgroundColor: ColorConstants.primary,
                                  child: Text(user["uid"][0]),
                                ),
                                trailing: const Icon(Icons.arrow_right),
                                title: Text(user["uid"]),
                                subtitle: Text(controller.formatTimestamp(user["createdAt"])),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
