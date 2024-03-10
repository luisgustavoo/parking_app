import 'dart:convert';

import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/helpers/constants.dart';
import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/register/repository/register_repository.dart';

class RegisterService {
  RegisterService({
    required RegisterRepository registerRepository,
    required LocalStorage localStorage,
    required Log log,
  })  : _registerRepository = registerRepository,
        _localStorage = localStorage,
        _log = log;

  final RegisterRepository _registerRepository;
  final Log _log;
  final LocalStorage _localStorage;

  Future<void> register(UserModel userModel) async {
    try {
      final user = await _registerRepository.register(userModel);

      if (user != null) {
        await _saveLocalUser(user);
      }
    } on RestClientException catch (e, s) {
      _log.error('Erro ao cadastrar usuário', e, s);
      throw Failure(message: 'Erro ao cadastrar usuário');
    }
  }

  Future<void> _saveLocalUser(UserModel user) async {
    await _localStorage.write(
      Constants.localUserKey,
      jsonEncode(
        user.toMap(),
      ),
    );
  }
}
