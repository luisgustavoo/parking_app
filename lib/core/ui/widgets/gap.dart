import 'package:flutter/material.dart';
import 'package:parking_app/core/ui/extensions/screen_extension.dart';

class Gap extends StatelessWidget {
  const Gap({
    double? width,
    double? height,
    super.key,
  })  : _width = width,
        _height = height;

  Gap.vertical(double height)
      : _width = 0,
        _height = height.h;
  Gap.horizontal(double width)
      : _width = width.w,
        _height = 0;

  final double? _height;
  final double? _width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height ?? 0,
      width: _width ?? 0,
    );
  }
}
