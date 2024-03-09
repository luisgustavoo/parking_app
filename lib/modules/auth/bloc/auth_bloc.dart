import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/auth/service/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthService authService,
    required Log log,
  })  : _authService = authService,
        _log = log,
        super(const AuthState.initial()) {
    on<AuthRegisterEvent>(_register);
  }

  final AuthService _authService;
  final Log _log;

  Future<void> _register(
    AuthRegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: AuthStatus.loading));
      final userModel = UserModel(
        name: event.name,
        cpf: event.cpf,
        password: event.password,
      );
      await _authService.register(userModel);
      emit(
        state.copyWith(
          status: AuthStatus.success,
        ),
      );
    } on Exception catch (e, s) {
      emit(state.copyWith(status: AuthStatus.failure));
      _log.error('Erro ao registrar o usuário', e, s);
      throw Failure(message: 'Erro ao registrar o usuário');
    }
  }
}
