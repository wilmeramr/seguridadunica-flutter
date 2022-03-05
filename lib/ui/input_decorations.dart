import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        hintText: hintText,
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: Colors.deepPurple,
              )
            : null);
  }
}
