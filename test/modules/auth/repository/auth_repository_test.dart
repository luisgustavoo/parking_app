import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/local_storages/local_security_storage.dart';
import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/models/token_model.dart';
import 'package:parking_app/models/user_model.dart';

import 'package:parking_app/modules/auth/repository/auth_repository.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/local_security_storage/mock_local_security_storage.dart';
import '../../../core/local_storage/mock_local_storage.dart';
import '../../../core/log/mock_log.dart';
import '../../../core/rest_client/mock_rest_client.dart';
import '../../../core/rest_client/mock_rest_client_exception.dart';
import '../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late RestClient mockRestClient;
  late Log mockLog;
  late AuthRepository authRepository;
  late LocalStorage mockLocalStorage;
  late LocalSecurityStorage mockLocalSecurityStorage;

  const userModel = UserModel(
    id: 1,
    name: 'Sr João',
    cpf: '12345678912',
    password: '123456',
  );

  final tokenModel = TokenModel(
    accessToken: 'accessToken',
    refreshToken: 'refreshToken',
    type: 'Bearer',
  );

  setUp(() {
    mockLocalSecurityStorage = MockLocalSecurityStorage();
    mockLocalStorage = MockLocalStorage();
    mockLog = MockLog();
    mockRestClient = MockRestClient(
      localSecurityStorage: mockLocalSecurityStorage,
      localStorage: mockLocalStorage,
      log: mockLog,
    );

    authRepository = AuthRepository(restClient: mockRestClient, log: mockLog);
  });

  group('Group register', () {
    test('Should register user with success', () async {
      final jsonData = FixtureReader.getJsonData(
        '/modules/auth/repository/fixture/register_response.json',
      );

      final response = jsonDecode(jsonData) as Map<String, dynamic>;

      when(
        () => mockRestClient.post<Map<String, dynamic>>(
          any(),
          data: userModel.toMap(),
        ),
      ).thenAnswer(
        (_) async => MockRestClientResponse<Map<String, dynamic>>(
          statusCode: 200,
          data: response,
        ),
      );

      final userModelExpected = await authRepository.register(userModel);

      expect(userModelExpected, isNotNull);
      expect(userModelExpected, userModel);
    });

    test('Should return null response', () async {
      when(
        () => mockRestClient.post<Map<String, dynamic>>(
          any(),
          data: userModel.toMap(),
        ),
      ).thenAnswer(
        (_) async => MockRestClientResponse<Map<String, dynamic>>(),
      );

      final userModelExpected = await authRepository.register(userModel);

      expect(userModelExpected, isNull);
    });

    test('Should return failure', () async {
      when(
        () => mockRestClient.post<Map<String, dynamic>>(
          any(),
          data: userModel.toMap(),
        ),
      ).thenThrow(
        MockRestClientException(),
      );

      final call = authRepository.register;

      expect(call(userModel), throwsA(isA<Failure>()));
    });
  });

  group('Group login', () {
    test('Should login user with success', () async {
      final jsonData = FixtureReader.getJsonData(
        '/modules/auth/repository/fixture/login_response.json',
      );

      final response = jsonDecode(jsonData) as Map<String, dynamic>;

      when(
        () => mockRestClient.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => MockRestClientResponse<Map<String, dynamic>>(
          statusCode: 200,
          data: response,
        ),
      );

      final tokenModelExpected =
          await authRepository.login(userModel.cpf, userModel.password);

      expect(tokenModel, isNotNull);
      expect(tokenModelExpected, tokenModel);
    });

    test('Should return null response', () async {
      when(
        () => mockRestClient.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => MockRestClientResponse<Map<String, dynamic>>(),
      );

      final tokenModelExpected =
          await authRepository.login(userModel.cpf, userModel.password);

      expect(tokenModelExpected, isNull);
    });

    test('Should return failure', () async {
      when(
        () => mockRestClient.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
        ),
      ).thenThrow(
        MockRestClientException(),
      );

      final call = authRepository.login;

      expect(call(userModel.cpf, userModel.password), throwsA(isA<Failure>()));
    });
  });
}
