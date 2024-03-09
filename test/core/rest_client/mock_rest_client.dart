import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/rest_client/local_storages/local_security_storage.dart';
import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';

class MockRestClient extends Mock implements RestClient {
  MockRestClient({
    required this.localStorage,
    required this.localSecurityStorage,
    required this.log,
  }) {
    when(unAuth).thenReturn(this);
    when(auth).thenReturn(this);
  }

  final LocalStorage localStorage;
  final LocalSecurityStorage localSecurityStorage;
  final Log log;
}
