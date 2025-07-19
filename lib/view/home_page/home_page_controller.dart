import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:seekhelpers_assignment/core/enums/view_state.dart';
import 'package:seekhelpers_assignment/core/helper/shared_pref_helper.dart';
import '../../core/helper/app_logger.dart';

class HomePageController extends GetxController {
  TextEditingController searchController = TextEditingController();
  ViewState state = ViewState.loading;

  List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> filteredUsers = [];
  String errorMessage = '';
  String uid = 'Null';

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      state = ViewState.loading;
      update();

      // final querySnapshot = await _firestore.collection('users').get();

      // allUsers = querySnapshot.docs
      //     .map((doc) => doc.data() as Map<String, dynamic>)
      //     .toList();

      // AppLogger.log("All users: $allUsers");

      uid = await SharedPrefHelper.getString("uid") ?? "Null";
      filterUsers(""); // Initialize filteredUsers with default

      state = ViewState.complete;
      AppLogger.log("Data fetched successfully: $uid");
    } catch (e) {
      state = ViewState.error;
      errorMessage = "Error getting user list.";
      AppLogger.log("Error getting checklist: $e");
    }
    update();
  }

  void filterUsers(String query) {
    if (query.trim().isEmpty) {
      filteredUsers = allUsers.where((user) => user["uid"] != uid).toList();
    } else {
      filteredUsers = allUsers.where((user) {
        return user["uid"].toLowerCase().contains(query.toLowerCase()) &&
            user["uid"] != uid;
      }).toList();
    }

   
    AppLogger.log("Filtered users: $filteredUsers");
    update();
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'No date provided';
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd – hh:mm a').format(dateTime);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
