import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:seekhelpers_assignment/core/constants/color_constants.dart';
import 'package:seekhelpers_assignment/view/home_page/home_page.dart';
import 'core/network/injector.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // navigatorKey: AppConstants.globalNavKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:ColorConstants.primary),
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
            borderSide: BorderSide(color:ColorConstants.primary, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.black),
        ),
      ),
      home: HomePage(),
    );
  }
}
