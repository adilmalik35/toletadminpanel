import 'package:flutter/material.dart';

class CustomizedButton extends StatelessWidget {
  final String title;
  final Color colorButton;
  final double height;
  final double widht;
  final Color colorText;
  final double fontSize;
  final VoidCallback? onPressed; // Add onPressed property

  CustomizedButton({
    Key? key,
    required this.title,
    required this.colorButton,
    required this.height,
    required this.widht,
    required this.colorText,
    required this.fontSize,
    this.onPressed, // Make it optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Trigger the callback when tapped
      child: Container(
        height: height,
        width: widht,
        decoration: BoxDecoration(
          color: colorButton,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: colorText,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
