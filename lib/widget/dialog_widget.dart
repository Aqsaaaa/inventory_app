import 'package:flutter/material.dart';

void showSnackBarr(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required Color textColor,
    required Color buttonColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 1),
      ),
    );
  }