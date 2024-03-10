import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/user_model.dart';
import 'package:parking_app/modules/register/service/register_service.dart';

part 'auth_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<AuthEvent, RegisterState> {
  RegisterBloc({
    required RegisterService authService,
    required Log log,
  })  : _authService = authService,
        _log = log,
        super(RegisterInitial()) {
    on<AuthRegisterEvent>(_register);
  }

  final RegisterService _authService;
  final Log _log;

  Future<void> _register(
    AuthRegisterEvent event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      emit(RegisterLoading());
      final userModel = UserModel(
        name: event.name,
        cpf: event.cpf,
        password: event.password,
      );
      await _authService.register(userModel);
      emit(
        RegisterSuccess(),
      );
    } on Exception catch (e, s) {
      emit(RegisterFailure());
      _log.error('Erro ao registrar o usuário', e, s);
      throw Failure(message: 'Erro ao registrar o usuário');
    }
  }
}
