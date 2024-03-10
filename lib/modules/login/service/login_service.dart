import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/helpers/constants.dart';
import 'package:parking_app/core/rest_client/local_storages/local_security_storage.dart';
import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/token_model.dart';
import 'package:parking_app/modules/login/repository/login_repository.dart';

class LoginService {
  LoginService({
    required LoginRepository loginRepository,
    required LocalStorage localStorage,
    required LocalSecurityStorage localSecurityStorage,
    required Log log,
  })  : _loginRepository = loginRepository,
        _localStorage = localStorage,
        _localSecurityStorage = localSecurityStorage,
        _log = log;

  final LoginRepository _loginRepository;
  final Log _log;
  final LocalStorage _localStorage;
  final LocalSecurityStorage _localSecurityStorage;

  Future<void> login(String cpf, String password) async {
    try {
      final tokenModel = await _loginRepository.login(cpf, password);

      if (tokenModel != null) {
        await _saveAccessToken(tokenModel);
      }
    } on RestClientException catch (e, s) {
      _log.error('Erro realizar login', e, s);
      throw Failure(message: 'Erro realizar login');
    }
  }

  Future<void> _saveAccessToken(TokenModel tokenModel) async {
    await _localStorage.write(Constants.accessTokenKey, tokenModel.accessToken);
    await _localSecurityStorage.write(
      Constants.refreshTokenKey,
      tokenModel.refreshToken,
    );
  }
}
