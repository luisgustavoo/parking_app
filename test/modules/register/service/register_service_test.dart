import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/helpers/constants.dart';
import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/register/repository/register_repository.dart';
import 'package:parking_app/modules/register/service/register_service.dart';

import '../../../core/local_storage/mock_local_storage.dart';
import '../../../core/log/mock_log.dart';
import '../../../core/rest_client/mock_rest_client_exception.dart';
import '../mocks/mock_register_repository.dart';

class MockAuthRepository extends Mock implements RegisterRepository {}

void main() {
  late RegisterRepository mockRegisterRepository;
  late Log mocklog;
  late LocalStorage mockLocalStorage;
  late RegisterService registerService;

  const userModel = UserModel(
    id: 1,
    name: 'Sr João',
    cpf: '12345678912',
    password: '123456',
  );

  setUp(() {
    mocklog = MockLog();
    mockLocalStorage = MockLocalStorage();
    mockRegisterRepository = MockRegisterRepository();

    registerService = RegisterService(
      registerRepository: mockRegisterRepository,
      localStorage: mockLocalStorage,
      log: mocklog,
    );

    registerFallbackValue(userModel);
  });

  test('Should register user with success', () async {
    when(() => mockRegisterRepository.register(any()))
        .thenAnswer((_) async => userModel);
    when(
      () => mockLocalStorage.write(
        Constants.localUserKey,
        jsonEncode(
          userModel.toMap(),
        ),
      ),
    ).thenAnswer((_) async => _);

    await registerService.register(userModel);

    verify(() => mockRegisterRepository.register(any())).called(1);
    verify(
      () => mockLocalStorage.write(
        Constants.localUserKey,
        jsonEncode(
          userModel.toMap(),
        ),
      ),
    ).called(1);
  });

  test('Must return a null user', () async {
    when(() => mockRegisterRepository.register(any()))
        .thenAnswer((_) async => null);

    await registerService.register(userModel);

    verify(() => mockRegisterRepository.register(any())).called(1);
    verifyNever(
      () => mockLocalStorage.write(
        Constants.localUserKey,
        jsonEncode(
          userModel.toMap(),
        ),
      ),
    );
  });

  test('Should return a failure', () async {
    when(() => mockRegisterRepository.register(any()))
        .thenThrow(MockRestClientException());

    final call = registerService.register;

    expect(call(userModel), throwsA(isA<Failure>()));
    verify(() => mockRegisterRepository.register(any())).called(1);
    verifyNever(
      () => mockLocalStorage.write(
        Constants.localUserKey,
        userModel,
      ),
    );
  });
}
