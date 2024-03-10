import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/models/token_model.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/login/repository/login_repository.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_log.dart';
import '../../../core/rest_client/mock_rest_client.dart';
import '../../../core/rest_client/mock_rest_client_exception.dart';
import '../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late RestClient mockRestClient;
  late Log mockLog;
  late LoginRepository loginRepository;

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
    mockRestClient = MockRestClient();
    mockLog = MockLog();
    loginRepository = LoginRepository(restClient: mockRestClient, log: mockLog);
  });

  group('Group login', () {
    test('Should login user with success', () async {
      final jsonData = FixtureReader.getJsonData(
        '/modules/login/repository/fixture/login_response.json',
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
          await loginRepository.login(userModel.cpf, userModel.password);

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
          await loginRepository.login(userModel.cpf, userModel.password);

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

      final call = loginRepository.login;

      expect(call(userModel.cpf, userModel.password), throwsA(isA<Failure>()));
    });
  });
}
