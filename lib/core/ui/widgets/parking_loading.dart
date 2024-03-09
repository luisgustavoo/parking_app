import 'package:flutter/material.dart';
import 'package:parking_app/core/ui/extensions/screen_extension.dart';

class ParkingLoading extends StatelessWidget {
  const ParkingLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
        strokeWidth: 1.w,
      ),
    );
  }
}
