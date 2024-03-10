import 'package:flutter/widgets.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:parking_app/modules/vehicles/bloc/vehicles_bloc.dart';
import 'package:parking_app/modules/vehicles/repository/vehicles_repository.dart';

class VehiclesModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings {
    return [
      Bind.lazySingleton(
        (i) => VehiclesRepository(
          restClient: i(),
          log: i(),
        ),
      ),
      Bind.lazySingleton(
        (i) => VehiclesBloc(
          vehiclesRepository: i(),
          log: i(),
        )..add(VehiclesFindAllEvent()),
      ),
    ];
  }

  @override
  String get moduleRouteName => '/vehicles';

  @override
  Map<String, WidgetBuilder> get pages {
    return {
      '/': (context) => Container(),
      '/register': (context) => Container(),
    };
  }
}
