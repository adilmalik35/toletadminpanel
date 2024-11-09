import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'DashboardScreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscureText = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1),
              Center(
                child: Image.asset(
                  'assets/images/tolet.png',
                  width: screenWidth * 0.4, // Logo size
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Login',
                      style: TextStyle(
                        color: Color(0xFF192747), // Title text color
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.07,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Email',
                      style: TextStyle(
                        color: Color(0xFF8E8E93), // Label text color
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'admin@example.com',
                        filled: true,
                        fillColor: Color(0xFFF2F3F3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'Password',
                      style: TextStyle(
                        color: Color(0xFF8E8E93), // Label text color
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscureText,
                      decoration: InputDecoration(
                        hintText: '******',
                        suffixIcon: IconButton(
                          icon: Icon(_isObscureText ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isObscureText = !_isObscureText;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Color(0xFFF2F3F3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              Center(
                child: isLoading
                    ? CircularProgressIndicator(color: Color(0xFF192747)) // Loading spinner color
                    : ElevatedButton(
                  onPressed: () {
                    Get.off(() => DashboardScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF192747), // Button background color
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.015,
                      horizontal: screenWidth * 0.3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white, // Button text color
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
