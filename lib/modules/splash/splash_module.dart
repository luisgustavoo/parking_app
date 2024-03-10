// import 'package:flutter/widgets.dart';

// import 'package:flutter_getit/flutter_getit.dart';
// import 'package:parking_app/core/rest_client/local_storages/shared_preferences_local_storage_impl.dart';
// import 'package:parking_app/modules/splash/bloc/splash_bloc.dart';
// import 'package:parking_app/modules/splash/page/splash_page.dart';

// class SplashModule extends FlutterGetItModule {
//   @override
//   List<Bind<Object>> get bindings {
//     return [
//       Bind.lazySingleton(
//         (i) => SharedPreferencesLocalStorageImpl(),
//       ),
//       Bind.lazySingleton((i) {
//         return SplashBloc(storage: i())..add(SplashVerifyLocalUserEvent());
//       }),
//     ];
//   }

//   @override
//   String get moduleRouteName => '/';

//   @override
//   Map<String, WidgetBuilder> get pages {
//     return {
//       '/': (context) => const SplashPage(),
//     };
//   }
// }
