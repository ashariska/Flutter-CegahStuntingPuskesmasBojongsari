import 'package:flutter/material.dart';
import 'package:stunting_web/constants/colors.dart';

BoxDecoration kHeaderDecoration = BoxDecoration(
  gradient: const LinearGradient(
    colors: [CustomColor.bgMain, CustomColor.scaffoldBg],
  ),
);

class General {
  static Future<void> showSnackBar(
    BuildContext context,
    dynamic message, {
    int? durationSeconds,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          width: 200, // Lebar maksimum Snackbar
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        duration: Duration(seconds: durationSeconds ?? 2),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.black87,
      ),
    );
  }
}
