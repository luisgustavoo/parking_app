import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/helpers/constants.dart';
import 'package:parking_app/core/rest_client/local_storages/local_security_storage.dart';
import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/token_model.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/login/repository/login_repository.dart';
import 'package:parking_app/modules/login/service/login_service.dart';
import 'package:parking_app/modules/register/repository/register_repository.dart';

import '../../../core/local_security_storage/mock_local_security_storage.dart';
import '../../../core/local_storage/mock_local_storage.dart';
import '../../../core/log/mock_log.dart';
import '../../../core/rest_client/mock_rest_client_exception.dart';
import '../mocks/mock_login_repository.dart';

class MockAuthRepository extends Mock implements RegisterRepository {}

void main() {
  late LoginRepository mockLoginRepository;
  late Log mocklog;
  late LocalStorage mockLocalStorage;
  late LocalSecurityStorage mockLocalSecurityStorage;
  late LoginService authService;

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
    mocklog = MockLog();
    mockLocalStorage = MockLocalStorage();
    mockLocalSecurityStorage = MockLocalSecurityStorage();
    mockLoginRepository = MockLoginRepository();

    authService = LoginService(
      loginRepository: mockLoginRepository,
      localStorage: mockLocalStorage,
      localSecurityStorage: mockLocalSecurityStorage,
      log: mocklog,
    );

    registerFallbackValue(userModel);
  });

  test('Must log in successfully', () async {
    when(
      () => mockLoginRepository.login(
        userModel.cpf,
        userModel.password,
      ),
    ).thenAnswer((_) async => tokenModel);
    when(
      () => mockLocalStorage.write(
        Constants.accessTokenKey,
        tokenModel.accessToken,
      ),
    ).thenAnswer((_) async => _);

    when(
      () => mockLocalSecurityStorage.write(
        Constants.refreshTokenKey,
        tokenModel.refreshToken,
      ),
    ).thenAnswer((_) async => _);

    await authService.login(
      userModel.cpf,
      userModel.password,
    );

    verify(
      () => mockLoginRepository.login(
        userModel.cpf,
        userModel.password,
      ),
    ).called(1);
    verify(
      () => mockLocalStorage.write(
        Constants.accessTokenKey,
        tokenModel.accessToken,
      ),
    ).called(1);
    verify(
      () => mockLocalSecurityStorage.write(
        Constants.refreshTokenKey,
        tokenModel.refreshToken,
      ),
    ).called(1);
  });

  test('Must return a null user', () async {
    when(
      () => mockLoginRepository.login(
        userModel.cpf,
        userModel.password,
      ),
    ).thenAnswer((_) async => null);

    await authService.login(
      userModel.cpf,
      userModel.password,
    );

    verify(
      () => mockLoginRepository.login(
        userModel.cpf,
        userModel.password,
      ),
    ).called(1);
    verifyNever(
      () => mockLocalStorage.write(
        Constants.accessTokenKey,
        tokenModel.accessToken,
      ),
    );
    verifyNever(
      () => mockLocalSecurityStorage.write(
        Constants.refreshTokenKey,
        tokenModel.refreshToken,
      ),
    );
  });

  test('Should return a failure', () async {
    when(
      () => mockLoginRepository.login(
        userModel.cpf,
        userModel.password,
      ),
    ).thenThrow(MockRestClientException());

    final call = authService.login;

    expect(call(userModel.cpf, userModel.password), throwsA(isA<Failure>()));
    verify(() => mockLoginRepository.login(userModel.cpf, userModel.password))
        .called(1);
    verifyNever(
      () => mockLocalStorage.write(
        Constants.accessTokenKey,
        tokenModel.accessToken,
      ),
    );
    verifyNever(
      () => mockLocalSecurityStorage.write(
        Constants.refreshTokenKey,
        tokenModel.refreshToken,
      ),
    );
  });
}
