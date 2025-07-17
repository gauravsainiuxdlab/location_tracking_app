import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekhelpers_assignment/view/user_details_page/user_details_page_controller.dart';

import '../../core/constants/color_constants.dart';
import '../../core/enums/view_state.dart';
import '../../models/user_model.dart';

class UserDetailPage extends StatelessWidget {
  final User user;
  final UserDetailsPageController controller = Get.put(UserDetailsPageController());

  UserDetailPage({super.key, required this.user}) {
    controller.loadUser(user); // Pass user to controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Detail"),
        backgroundColor: ColorConstants.primary,
      ),
      body: GetBuilder<UserDetailsPageController>(
        builder: (controller) {
          if (controller.state == ViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.state == ViewState.error) {
            return Center(child: Text(controller.message));
          } else if (controller.user == null) {
            return const Center(child: Text("User not found."));
          }

          final user = controller.user!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSection("Basic Info", [
                  _buildTile("Name", user.name),
                  _buildTile("Username", user.username),
                  _buildTile("Email", user.email),
                  _buildTile("Phone", user.phone),
                  _buildTile("Website", user.website),
                ]),
                _buildSection("Address", [
                  _buildTile("Street", user.address.street),
                  _buildTile("Suite", user.address.suite),
                  _buildTile("City", user.address.city),
                  _buildTile("Zipcode", user.address.zipcode),
                  _buildTile("Geo", "${user.address.geo.lat}, ${user.address.geo.lng}"),
                ]),
                _buildSection("Company", [
                  _buildTile("Name", user.company.name),
                  _buildTile("Catch Phrase", user.company.catchPhrase),
                  _buildTile("Business", user.company.bs),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTile(String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
