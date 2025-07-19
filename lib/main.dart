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
import 'view/user_form_page/user_form_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options:
            Platform.isAndroid
                ? const FirebaseOptions(
                  apiKey: "AIzaSyCkxf2p9xxPUeWTT6K2a9sGfRaTOxXi3jE",
                  appId: "1:591237109795:android:12c9590509a232179d7996",
                  messagingSenderId: "591237109795",
                  projectId: "location-tracking-app-d1754",
                  storageBucket: "location-tracking-app-d1754.appspot.com",
                )
                : null,
      );
      print('✅ Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization failed: $e');
    }
  } else {
    print('ℹ️ Firebase already initialized, skipping.');
  }
  final bool isUid = await SharedPrefHelper.containsKey("uid");
  if (!isUid) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Step 1: Add a new document with a timestamp
    DocumentReference docRef = await users.add({"createdAt": DateTime.now()});

    // Step 2: Get the auto-generated ID
    final String uid = docRef.id;

    // Step 3: Update the same document with the UID
    await docRef.update({"uid": uid});

    SharedPrefHelper.setString(key: 'uid', value: uid);
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
