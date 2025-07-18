import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../core/helper/app_logger.dart';
import '../../core/repository/app_repository.dart';
import '../../models/user_model.dart';

enum ViewState { loading, empty, complete, error }

class HomePageController extends GetxController {
  TextEditingController searchController=TextEditingController();
  ViewState state = ViewState.loading;
  List<User> users = [];
  List<Map<String,dynamic>> allUsers = [];
  String errorMessage = '';


  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }
Future<void> fetchUsers() async {
    try {
       final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 
      state=ViewState.loading;
      final response =
          await _firestore.collection('users').get();
      allUsers = response.docs as List<Map<String,dynamic>>;
      
      state=ViewState.complete;
      AppLogger.log(" Data fetched successfully${response.docs }");
      
    } catch (e) {
     state=ViewState.error;
      AppLogger.log(" Error getting checklist: $e");
    }
    update();
  }

  //  filterUsers(String query) {
  //   if (query.isEmpty) {
  //     users=allUsers;
  //     update();
  //   } else {
  //     users = allUsers.where((user) {
  //       return user.name.toLowerCase().contains(query) ||
  //           user.username.toLowerCase().contains(query) ||
  //           user.email.toLowerCase().contains(query);
  //     }).toList();
  //     update();
  //   }
  // }
}
