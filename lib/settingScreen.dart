import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toletadminpanel/constants.dart';
import 'package:toletadminpanel/customize_button.dart';
import 'package:toletadminpanel/splashScreen.dart';

class Settingscreen extends StatefulWidget {
  @override
  _SettingscreenState createState() => _SettingscreenState();
}

class _SettingscreenState extends State<Settingscreen> {
  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen width and height
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomizedButton(
            colorButton: Color(constcolor.App_blue_color),
            colorText: Colors.white,
            fontSize: screenWidth * 0.05, // Responsive button text size
            height: screenHeight * 0.07, // Responsive button height
            title: 'Logout', // Button title
            widht: screenWidth * 0.60, // Responsive button width
            onPressed: () async {
              try {
                // Sign out from Firebase
                await FirebaseAuth.instance.signOut();

                // Clear all shared preferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Navigate to the SplashScreen
                Get.offAll(() => SplashScreen(), transition: Transition.fadeIn);
              } catch (e) {
                print("Error signing out: $e");
              }
            },
          ),
        ),
      ),
    );
  }
}
