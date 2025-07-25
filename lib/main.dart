import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:seekhelpers_assignment/core/constants/app_constants.dart';
import 'package:seekhelpers_assignment/core/constants/color_constants.dart';
import 'package:seekhelpers_assignment/core/helper/shared_pref_helper.dart';
import 'package:seekhelpers_assignment/view/home_page/home_page.dart';

import 'core/helper/app_logger.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: Platform.isAndroid
          ? const FirebaseOptions(
              apiKey: "AIzaSyCkxf2p9xxPUeWTT6K2a9sGfRaTOxXi3jE",
              appId: "1:591237109795:android:12c9590509a232179d7996",
              messagingSenderId: "591237109795",
              projectId: "location-tracking-app-d1754",
              storageBucket: "location-tracking-app-d1754.appspot.com",
            )
          : null,
    );
    AppLogger.log(' Firebase initialized successfully');
  } catch (e) {
    if (e.toString().contains("duplicate-app")) {
      AppLogger.log(" Firebase already initialized. Continuing...");
    } else {
      AppLogger.log(' Firebase initialization failed: $e');
    }
  }

  final bool isUid = await SharedPrefHelper.containsKey("uid");
  if (!isUid) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    DocumentReference docRef = await users.add({"createdAt": DateTime.now()});
    final String uid = docRef.id;

    await docRef.update({"uid": uid});
    SharedPrefHelper.setString(key: 'uid', value: uid);

    AppLogger.log(' New UID created and stored: $uid');
  } else {
    final existingUid = await SharedPrefHelper.getString("uid");
    AppLogger.log(' Existing UID found: $existingUid');
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: AppConstants.globalNavKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorConstants.primary),
        useMaterial3: true,

        // Customize elevated buttons globally
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorConstants.primary, // Button background
            foregroundColor: Colors.white, // Button text/icon color
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),

        // Customize loading indicator
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: ColorConstants.primary, // CircularProgressIndicator color
        ),

        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.primary, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.black),
        ),
      ),
      home: HomePage(),
    );
  }
}
