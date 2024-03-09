import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/helpers/constants.dart';
import 'package:parking_app/core/rest_client/local_storages/local_security_storage.dart';
import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/token_model.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/auth/repository/auth_repository.dart';

class AuthService {
  AuthService({
    required AuthRepository authRepository,
    required LocalStorage localStorage,
    required LocalSecurityStorage localSecurityStorage,
    required Log log,
  })  : _authRepository = authRepository,
        _localStorage = localStorage,
        _localSecurityStorage = localSecurityStorage,
        _log = log;

  final AuthRepository _authRepository;
  final Log _log;
  final LocalStorage _localStorage;
  final LocalSecurityStorage _localSecurityStorage;

  Future<void> register(UserModel userModel) async {
    try {
      final user = await _authRepository.register(userModel);

      if (user != null) {
        await _saveLocalUser(user);
      }
    } on RestClientException catch (e, s) {
      _log.error('Erro ao cadastrar usuário', e, s);
      throw Failure(message: 'Erro ao cadastrar usuário');
    }
  }

  Future<void> login(String cpf, String password) async {
    try {
      final tokenModel = await _authRepository.login(cpf, password);

      if (tokenModel != null) {
        await _saveAccessToken(tokenModel);
      }
    } on RestClientException catch (e, s) {
      _log.error('Erro realizar login', e, s);
      throw Failure(message: 'Erro realizar login');
    }
  }

  Future<void> _saveLocalUser(UserModel user) async {
    await _localStorage.write(Constants.localUserKey, user);
  }

  Future<void> _saveAccessToken(TokenModel tokenModel) async {
    await _localStorage.write(Constants.accessTokenKey, tokenModel.accessToken);
    await _localSecurityStorage.write(
      Constants.refreshTokenKey,
      tokenModel.refreshToken,
    );
  }
}
