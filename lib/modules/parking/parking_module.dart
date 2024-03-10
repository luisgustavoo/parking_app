import 'package:flutter/widgets.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:parking_app/modules/parking/page/parking_page.dart';

class ParkingModule extends FlutterGetItModule {
  @override
  String get moduleRouteName => '/parking';

  @override
  Map<String, WidgetBuilder> get pages {
    return {
      '/': (context) => const ParkingPage(),
    };
  }
}
