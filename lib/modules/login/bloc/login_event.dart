part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginUserEvent extends LoginEvent {
  const LoginUserEvent({
    required this.cpf,
    required this.password,
  });

  final String cpf;
  final String password;
}
