import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/helpers/constants.dart';
import 'package:parking_app/core/rest_client/local_storages/local_security_storage.dart';
import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/auth/repository/auth_repository.dart';
import 'package:parking_app/modules/auth/service/auth_service.dart';

import '../../../core/local_security_storage/mock_local_security_storage.dart';
import '../../../core/local_storage/mock_local_storage.dart';
import '../../../core/log/mock_log.dart';
import '../../../core/rest_client/mock_rest_client_exception.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository mockRepository;
  late Log mocklog;
  late LocalStorage mockLocalStorage;
  late LocalSecurityStorage mockLocalSecurityStorage;
  late AuthService authService;

  const userModel = UserModel(
    id: 1,
    name: 'Sr João',
    cpf: '12345678912',
    password: '123456',
  );

  setUp(() {
    mocklog = MockLog();
    mockLocalStorage = MockLocalStorage();
    mockLocalSecurityStorage = MockLocalSecurityStorage();
    mockRepository = MockAuthRepository();

    authService = AuthService(
      authRepository: mockRepository,
      localStorage: mockLocalStorage,
      localSecurityStorage: mockLocalSecurityStorage,
      log: mocklog,
    );

    registerFallbackValue(userModel);
  });

  test('Should register user with success', () async {
    when(() => mockRepository.register(any()))
        .thenAnswer((_) async => userModel);
    when(
      () => mockLocalStorage.write(
        Constants.localUserKey,
        userModel,
      ),
    ).thenAnswer((_) async => _);

    await authService.register(userModel);

    verify(() => mockRepository.register(any())).called(1);
    verify(
      () => mockLocalStorage.write(
        Constants.localUserKey,
        userModel,
      ),
    ).called(1);
  });

  test('Must return a null user', () async {
    when(() => mockRepository.register(any())).thenAnswer((_) async => null);

    await authService.register(userModel);

    verify(() => mockRepository.register(any())).called(1);
    verifyNever(
      () => mockLocalStorage.write(
        Constants.localUserKey,
        userModel,
      ),
    );
  });

  test('Should return a failure', () async {
    when(() => mockRepository.register(any()))
        .thenThrow(MockRestClientException());

    final call = authService.register;

    expect(call(userModel), throwsA(isA<Failure>()));
    verify(() => mockRepository.register(any())).called(1);
    verifyNever(
      () => mockLocalStorage.write(
        Constants.localUserKey,
        userModel,
      ),
    );
  });
}
