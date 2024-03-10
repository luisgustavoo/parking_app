import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/user_model.dart';

class RegisterRepository {
  RegisterRepository({
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
}
