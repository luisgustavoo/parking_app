import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/token_model.dart';
import 'package:parking_app/models/user_model.dart';

class AuthRepository {
  AuthRepository({
    required RestClient restClient,
    required Log log,
  })  : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  Future<UserModel?> register(UserModel userModel) async {
    try {
      final response = await _restClient.unAuth().post<Map<String, dynamic>>(
            '/users',
            data: userModel.toMap(),
          );
      if (response.data != null) {
        return UserModel.fromMap(Map.from(response.data!));
      }

      return null;
    } on RestClientException catch (e, s) {
      _log.error('Erro ao cadastrar usuário', e, s);
      throw Failure(message: 'Erro ao cadastrar usuário');
    }
  }

  Future<TokenModel?> login(String cpf, String password) async {
    try {
      final response = await _restClient.unAuth().post<Map<String, dynamic>>(
        '/auth',
        data: <String, dynamic>{
          'cpf': cpf,
          'password': password,
        },
      );
      if (response.data != null) {
        return TokenModel.fromMap(Map.from(response.data!));
      }

      return null;
    } on RestClientException catch (e, s) {
      _log.error('Erro realizar login', e, s);
      throw Failure(message: 'Erro realizar login');
    }
  }
}
