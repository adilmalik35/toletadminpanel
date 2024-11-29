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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Account Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.person_outline, color: Colors.black),
                      title: Text(
                        "Account",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                      onTap: () {
                        // Navigate to account settings
                      },
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                ],
              ),
            ),

            // Notification Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.notifications_outlined, color: Colors.black),
                      title: Text(
                        "Notification",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                      onTap: () {
                        // Navigate to notification settings
                      },
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                ],
              ),
            ),

            // Appearance Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.remove_red_eye_outlined, color: Colors.black),
                      title: Text(
                        "Appearance",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                      onTap: () {
                        // Navigate to appearance settings
                      },
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                ],
              ),
            ),

            // Privacy Row
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.lock_outline, color: Colors.black),
                      title: Text(
                        "Privacy",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
                      onTap: () {
                        // Navigate to privacy settings
                      },
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                ],
              ),
            ),
            SizedBox(height: 50),
            // Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {
                  // Ensure button is laid out before navigation
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                    );
                  });
                },

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
          ],
        ),
      ),
    );
  }
}
