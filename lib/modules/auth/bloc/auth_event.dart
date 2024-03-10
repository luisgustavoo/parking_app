part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthRegisterEvent extends AuthEvent {
  const AuthRegisterEvent({
    required this.name,
    required this.cpf,
    required this.password,
  });

  final String name;
  final String cpf;
  final String password;
}
