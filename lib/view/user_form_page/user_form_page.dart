import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekhelpers_assignment/view/user_form_page/user_form_page_controller.dart';

import '../../core/constants/color_constants.dart';

class UserFormPage extends StatelessWidget {
  final UserFormController controller = Get.put(UserFormController());

  UserFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit User'),
        backgroundColor: ColorConstants.primary,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildInput("Name", controller.nameCtrl),
              _buildInput("Username", controller.usernameCtrl),
              _buildInput("Email", controller.emailCtrl, keyboardType: TextInputType.emailAddress),
              _buildInput("Phone", controller.phoneCtrl, keyboardType: TextInputType.phone),
              _buildInput("Website", controller.websiteCtrl),

              const SizedBox(height: 16),
              const Divider(),
              const Text("Address", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

              _buildInput("Street", controller.streetCtrl),
              _buildInput("Suite", controller.suiteCtrl),
              _buildInput("City", controller.cityCtrl),
              _buildInput("Zipcode", controller.zipcodeCtrl),

              const SizedBox(height: 16),
              const Divider(),
              _buildInput("Company Name", controller.companyCtrl),

              const SizedBox(height: 20),

              controller.isSubmitting.value
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstants.secondary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: controller.submitUser,
                child: const Text("Submit"),
              ),

              const SizedBox(height: 12),

            ],
          ),
        );
      }),
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
