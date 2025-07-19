import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:seekhelpers_assignment/core/helper/shared_pref_helper.dart';
import 'package:intl/intl.dart'; 
import '../../core/helper/app_logger.dart';
import '../../core/repository/app_repository.dart';
import '../../models/user_model.dart';

enum ViewState { loading, empty, complete, error }

class HomePageController extends GetxController {
  TextEditingController searchController = TextEditingController();
  ViewState state = ViewState.loading;
  List filteredUsers = [];
  List<Map<String, dynamic>>  allUsers = [];
  String errorMessage = '';
  String uid ='Null';
  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

      state = ViewState.loading;
final querySnapshot = await FirebaseFirestore.instance.collection('users').get();

// List of just document data (as Map<String, dynamic>)
 allUsers = querySnapshot.docs
    .map((doc) => doc.data() as Map<String, dynamic>)
    .toList();


      AppLogger.log("all users: $allUsers");

       uid = await SharedPrefHelper.getString("uid") ?? "Null";
      //       final ref = FirebaseDatabase.instance.ref();

      //       final userLocationRef = ref
      //           .child('users')
      //           .child(uid)
      //           .child('location'); // A new 'locations' child

      // // Now, use .push() to create a new unique entry under 'locations'
      //       await userLocationRef.push().set({
      //         // .push() generates a unique key, then .set() adds the data
      //         "lat": 6366.2727,
      //         "long": 672.3333,
      //         "timestamp": ServerValue.timestamp
      //       });
     await filterUsers("");
      state = ViewState.complete;
      AppLogger.log(" Data fetched successfully$uid");
    } catch (e) {
      state = ViewState.error;
      AppLogger.log(" Error getting checklist: $e");
    }
    update();
  }

   filterUsers(String query) {
    if (query.trim().isEmpty) {
      filteredUsers=allUsers;
    
      update();
    } else {
      filteredUsers = allUsers.where((user) {
        return user["uid"].toLowerCase().contains(query)&& user["uid"]!=uid;
      }).toList();
      update();
      
    }
    AppLogger.log("Filtered users: $filteredUsers");
  }

 String formatTimestamp(Timestamp? timestamp) {
  if (timestamp == null) return 'No date provided';
  DateTime dateTime = timestamp.toDate();
  return DateFormat('yyyy-MM-dd – hh:mm a').format(dateTime);
}
}
