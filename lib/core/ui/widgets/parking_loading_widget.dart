import 'package:flutter/material.dart';
import 'package:parking_app/core/ui/extensions/screen_extension.dart';
import 'package:parking_app/core/ui/extensions/theme_extension.dart';

class ParkingLoadingWidget extends StatelessWidget {
  const ParkingLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: context.primaryColor,
        strokeWidth: 1.w,
      ),
    );
  }
}
