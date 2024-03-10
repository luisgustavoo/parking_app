import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/register/repository/register_repository.dart';

import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_log.dart';
import '../../../core/rest_client/mock_rest_client.dart';
import '../../../core/rest_client/mock_rest_client_exception.dart';
import '../../../core/rest_client/mock_rest_client_response.dart';

void main() {
  late RestClient mockRestClient;
  late Log mockLog;
  late RegisterRepository registerRepository;

  const userModel = UserModel(
    id: 1,
    name: 'Sr João',
    cpf: '12345678912',
    password: '123456',
  );

  setUp(() {
    mockRestClient = MockRestClient();
    mockLog = MockLog();

    registerRepository =
        RegisterRepository(restClient: mockRestClient, log: mockLog);
  });

  group('Group register', () {
    test('Should register user with success', () async {
      final jsonData = FixtureReader.getJsonData(
        '/modules/register/repository/fixture/register_response.json',
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

      final userModelExpected = await registerRepository.register(userModel);

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

      final userModelExpected = await registerRepository.register(userModel);

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

      final call = registerRepository.register;

      expect(call(userModel), throwsA(isA<Failure>()));
    });
  });
}
