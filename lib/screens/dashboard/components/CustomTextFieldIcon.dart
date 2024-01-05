import 'package:flutter/material.dart';

class CustomTextFieldIcon extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final double width;
  final double height;
  final double fontSize;
  final IconData icon;
  final TextEditingController? controller;

  CustomTextFieldIcon({
    required this.hintText,
    this.onChanged,
    this.width = 250.0,
    this.height = 40.0,
    this.fontSize = 16.0,
    required this.icon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: fontSize,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjust padding
          prefixIcon: Icon(
            icon,
            size: 24, // Adjust icon size
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), // Apply border radius
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
        ),
        onChanged: onChanged,
        textAlign: TextAlign.left,
        maxLines: 1,
      ),
    );
  }
}