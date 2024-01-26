import 'package:flutter/material.dart';

Widget customTextField(
    {required TextEditingController controller, required String hintText}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      filled: true,
      hintStyle: TextStyle(color: Colors.grey[800]),
      hintText: hintText,
      fillColor: Colors.white70,
    ),
  );
}
