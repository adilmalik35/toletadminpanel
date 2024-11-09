import 'package:flutter/material.dart';

class CustomizedButton extends StatelessWidget {
  String title;
  Color colorButton;
  double height;
  double widht;
  Color colorText;
  double fontSize;

  CustomizedButton({
    Key? key,
    required this.title,
    required this.colorButton,
    required this.height,
    required this.widht,
    required this.colorText,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                color: colorText, fontWeight: FontWeight.bold, fontSize: fontSize),
          )),
    );
  }
}
