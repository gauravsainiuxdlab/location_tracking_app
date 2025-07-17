import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seekhelpers_assignment/core/helper/app_logger.dart';

class UserFormController extends GetxController {
  // Text controllers
  final nameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final suiteCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final zipcodeCtrl = TextEditingController();
  final companyCtrl = TextEditingController();

  final isSubmitting = false.obs;
  final submissionMessage = ''.obs;

  void submitUser() async {
    if(areFieldsNotEmpty()) {
      isSubmitting.value = true;
      submissionMessage.value = "";

      await Future.delayed(const Duration(seconds: 2)); // simulate API call

      isSubmitting.value = false;
      Get.snackbar("Response", "User submitted successfully!",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1));
      submissionMessage.value = "User submitted successfully!";
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } else {

    }
  }

  bool areFieldsNotEmpty() {
    final fields = {
      "Name": nameCtrl.text.trim(),
      "Username": usernameCtrl.text.trim(),
      "Email": emailCtrl.text.trim(),
      "Phone": phoneCtrl.text.trim(),
      "Website": websiteCtrl.text.trim(),
      "Street": streetCtrl.text.trim(),
      "Suite": suiteCtrl.text.trim(),
      "City": cityCtrl.text.trim(),
      "Zipcode": zipcodeCtrl.text.trim(),
      "Company": companyCtrl.text.trim(),
    };

    for (var entry in fields.entries) {
      if (entry.value.isEmpty) {
        AppLogger.log("${entry.key} is empty");
        Get.snackbar("Validation", "${entry.key} is empty",
        snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    }

    return true;
  }


  @override
  void onClose() {
    nameCtrl.dispose();
    usernameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    websiteCtrl.dispose();
    streetCtrl.dispose();
    suiteCtrl.dispose();
    cityCtrl.dispose();
    zipcodeCtrl.dispose();
    companyCtrl.dispose();
    super.onClose();
  }



}
