// import 'package:flutter_getit/flutter_getit.dart';
// import 'package:parking_app/core/rest_client/dio_rest_client.dart';
// import 'package:parking_app/core/rest_client/local_storages/flutter_secure_storage_local_storage_impl.dart';
// import 'package:parking_app/core/rest_client/local_storages/local_security_storage.dart';
// import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
// import 'package:parking_app/core/rest_client/local_storages/shared_preferences_local_storage_impl.dart';
// import 'package:parking_app/core/rest_client/logs/log.dart';
// import 'package:parking_app/core/rest_client/logs/log_impl.dart';
// import 'package:parking_app/core/rest_client/rest_client.dart';

// class ApplicationBinding extends ApplicationBindings {
//   @override
//   List<Bind<Object>> bindings() => [
//         Bind.lazySingleton<Log>(
//           (i) => LogImpl(),
//         ),
//         Bind.lazySingleton<LocalStorage>(
//           (i) => SharedPreferencesLocalStorageImpl(),
//         ),
//         Bind.lazySingleton<LocalSecurityStorage>(
//           (i) => FlutterSecureStorageLocalStorageImpl(),
//         ),
//         Bind.lazySingleton<RestClient>(
//           (i) => DioRestClient(
//             localStorage: i(),
//             localSecurityStorage: i(),
//             log: i(),
//           ),
//         ),
//       ];
// }
