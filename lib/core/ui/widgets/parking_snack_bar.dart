import 'package:flutter/material.dart';
import 'package:parking_app/core/ui/extensions/screen_extension.dart';

class ParkingSnackBar {
  ParkingSnackBar._();

  static SnackBar buildSnackBar({
    required Widget content,
    required Color backgroundColor,
    required String label,
    required VoidCallback onPressed,
    Key? key,
  }) {
    return SnackBar(
      key: key,
      backgroundColor: backgroundColor,
      elevation: 10,
      content: content,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.r),
      ),
      action: SnackBarAction(
        label: label,
        textColor: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}
