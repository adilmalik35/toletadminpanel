import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toletadminpanel/constants.dart';
import 'package:toletadminpanel/customize_button.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'LoginScreen.dart'; // Assuming GetX is used

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => LoginScreen());
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/ghar.png', width: 120, height: 120), // replace with your logo path
      ),
    );
  }
}

