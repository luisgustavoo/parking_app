import 'package:flutter_getit/flutter_getit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/bindings/aplication_binding.dart';
import 'package:parking_app/core/rest_client/local_storages/local_security_storage.dart';
import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';

import '../../local_security_storage/mock_local_security_storage.dart';
import '../../local_storage/mock_local_storage.dart';
import '../../log/mock_log.dart';
import '../../rest_client/mock_rest_client.dart';

class MockApplicationBinding extends Mock implements ApplicationBinding {
  @override
  List<Bind<Object>> bindings() => [
        Bind.lazySingleton<Log>(
          (i) => MockLog(),
        ),
        Bind.lazySingleton<LocalStorage>(
          (i) => MockLocalStorage(),
        ),
        Bind.lazySingleton<LocalSecurityStorage>(
          (i) => MockLocalSecurityStorage(),
        ),
        Bind.lazySingleton<RestClient>(
          (i) => MockRestClient(
            localStorage: i(),
            localSecurityStorage: i(),
            log: i(),
          ),
        ),
      ];
}
