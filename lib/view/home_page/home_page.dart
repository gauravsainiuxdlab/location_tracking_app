import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekhelpers_assignment/view/home_page/home_page_controller.dart';

import 'package:seekhelpers_assignment/view/share_location_page/share_location_page_map_view.dart';
import 'package:seekhelpers_assignment/view/show_route_view/show_route_page.dart' show LocationTracker;
import 'package:seekhelpers_assignment/view/user_details_page/user_details_page.dart';
import 'package:seekhelpers_assignment/view/user_form_page/user_form_page.dart';

import '../../core/constants/color_constants.dart';

class HomePage extends StatelessWidget {
  final HomePageController controller = Get.put(HomePageController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    floatingActionButton: FloatingActionButton(
        onPressed:(){
           Get.to(() => ShareLocationPageMapView());
        }
        ,
        child:Icon(Icons.location_on)
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
                    Text("Id:${controller.uid}"),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value)=>controller.filterUsers(value),
                      controller: controller.searchController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "search...",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: controller.filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = controller.filteredUsers[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          elevation: 2,
                          child: ListTile(
                            onTap: (){
                              Get.to(LocationTracker(uid: user["uid"],));
                            },
                            leading: CircleAvatar(
                              backgroundColor: ColorConstants.primary,
                              child: Text(user["uid"][0]),
                            ),
                            trailing: Icon(Icons.arrow_right),
                            title: Text(user["uid"]),
                            subtitle: Text(controller.formatTimestamp(user["createdAt"])),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(child: Icon(Icons.access_alarm),onPressed:(){
                    // Get.to(() => LocationTracker());
                  })
                ],
              );
          }
        },
      ),
    );
  }
}
