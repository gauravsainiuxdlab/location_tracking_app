import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekhelpers_assignment/view/home_page/home_page_controller.dart';
import 'package:seekhelpers_assignment/view/user_details_page/user_details_page.dart';
import 'package:seekhelpers_assignment/view/user_form_page/user_form_page.dart';

import '../../core/constants/color_constants.dart';

class HomePage extends StatelessWidget {
  final HomePageController controller = Get.put(HomePageController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
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
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      // onChanged: (value)=>controller.filterUsers(value),
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
                      itemCount: controller.users.length,
                      itemBuilder: (context, index) {
                        final user = controller.users[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          elevation: 2,
                          child: ListTile(
                            onTap: (){
                              Get.to(UserDetailPage(user: user));
                            },
                            leading: CircleAvatar(
                              backgroundColor: ColorConstants.primary,
                              child: Text(user.name[0]),
                            ),
                            trailing: Icon(Icons.arrow_right),
                            title: Text(user.name),
                            subtitle: Text(user.email),
                          ),
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
