import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/modules/login/service/login_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required LoginService loginService,
    required Log log,
  })  : _loginService = loginService,
        _log = log,
        super(const LoginState.initial()) {
    on<LoginUserEvent>(_login);
  }

  final LoginService _loginService;
  final Log _log;

  Future<void> _login(
    LoginUserEvent event,
    Emitter<LoginState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: LoginStatus.loading,
        ),
      );
      await _loginService.login(event.cpf, event.password);
      emit(
        state.copyWith(
          status: LoginStatus.success,
        ),
      );
    } on Exception catch (e, s) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          error: e,
        ),
      );
      _log.error('Erro realizer login', e, s);
    }
  }
}
