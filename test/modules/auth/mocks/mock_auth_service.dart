import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/rest_client/local_storages/local_security_storage.dart';
import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/modules/auth/repository/auth_repository.dart';
import 'package:parking_app/modules/auth/service/auth_service.dart';

class MockAuthService extends Mock implements AuthService {
  MockAuthService({
    required this.authRepository,
    required this.localStorage,
    required this.localSecurityStorage,
    required this.log,
  });
  final AuthRepository authRepository;
  final Log log;
  final LocalStorage localStorage;
  final LocalSecurityStorage localSecurityStorage;
}
