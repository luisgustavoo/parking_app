import 'package:flutter/widgets.dart';

class ParkingNavigator {
  ParkingNavigator._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState? get to => navigatorKey.currentState;
}
