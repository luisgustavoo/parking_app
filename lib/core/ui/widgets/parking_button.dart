import 'package:flutter/material.dart';
import 'package:parking_app/core/ui/extensions/screen_extension.dart';
import 'package:parking_app/core/ui/extensions/theme_extension.dart';
import 'package:parking_app/core/ui/widgets/parking_loading_widget.dart';

enum ParkingButtonStyle { primary, secondary }

class ParkingButton extends StatelessWidget {
  ParkingButton(
    String text, {
    double height = 40,
    double? width = 300,
    double borderRadius = 16,
    Color? color,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool disable = false,
    ParkingButtonStyle? style = ParkingButtonStyle.primary,
    super.key,
  })  : _text = text,
        _height = height,
        _width = width,
        _color = color,
        _borderRadius = borderRadius,
        _onPressed = onPressed,
        _disable = disable,
        _style = style,
        _isLoading = ValueNotifier<bool>(isLoading);

  final String _text;
  final double _height;
  final double? _width;
  final double _borderRadius;
  final Color? _color;
  final VoidCallback? _onPressed;
  final ValueNotifier<bool> _isLoading;
  final bool _disable;
  final ParkingButtonStyle? _style;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isLoading,
      builder: (context, isLoading, _) {
        return switch (_style) {
          ParkingButtonStyle.primary => _buildPrimaryButton(context, isLoading),
          ParkingButtonStyle.secondary =>
            _buildSecondaryButton(context, isLoading),
          null => throw UnimplementedError(),
        };
      },
    );
  }

  ElevatedButton _buildPrimaryButton(BuildContext context, bool isLoading) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(
          Size(_width!.w, _height.h),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius.r),
          ),
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) {
            if (_disable) {
              return context.disabledColor;
            }

            if (states.contains(MaterialState.pressed)) {
              return _color != null
                  ? _color.withOpacity(0.5)
                  : context.primaryColor.withOpacity(0.5);
            }

            return _color ?? context.primaryColor;
          },
        ),
      ),
      onPressed: isLoading ? null : _onPressed,
      child: isLoading
          ? const Padding(
              padding: EdgeInsets.all(8),
              child: ParkingLoadingWidget(),
            )
          : Text(
              _text,
              style: const TextStyle(color: Colors.white),
            ),
    );
  }

  TextButton _buildSecondaryButton(BuildContext context, bool isLoading) {
    return TextButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(
          Size(_width!.w, _height.h),
        ),
        // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //   RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(_borderRadius.r),
        //   ),
        // ),
        // backgroundColor: MaterialStateProperty.resolveWith<Color>(
        //   (states) {
        //     if (_disable) {
        //       return Constants.buttonColorDisabled;
        //     }

        //     if (states.contains(MaterialState.pressed)) {
        //       return _color != null
        //           ? _color.withOpacity(0.5)
        //           : context.primaryColor.withOpacity(0.5);
        //     }

        //     return _color ?? context.primaryColor;
        //   },
        // ),
      ),
      onPressed: isLoading ? null : _onPressed,
      child: isLoading
          ? SizedBox(
              height: 20.h,
              width: 20.w,
              child: const ParkingLoadingWidget(),
            )
          : Text(
              _text,
              style: TextStyle(color: context.primaryColor),
            ),
    );
  }
}
