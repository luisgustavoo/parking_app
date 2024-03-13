import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/register/service/register_service.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({
    required RegisterService registerService,
    required Log log,
  })  : _registerService = registerService,
        _log = log,
        super(const RegisterState.initial()) {
    on<RegisterUserEvent>(_register);
  }

  final RegisterService _registerService;
  final Log _log;

  Future<void> _register(
    RegisterUserEvent event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: RegisterStatus.loading,
        ),
      );
      final userModel = UserModel(
        name: event.name,
        cpf: event.cpf,
        password: event.password,
      );
      await _registerService.register(userModel);
      emit(
        state.copyWith(
          status: RegisterStatus.success,
        ),
      );
    } on Exception catch (e, s) {
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          error: e,
        ),
      );
      _log.error('Erro ao registrar o usuário', e, s);
    }
  }
}
