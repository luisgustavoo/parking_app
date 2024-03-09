part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthRegisterEvent extends AuthEvent {
  AuthRegisterEvent({
    required this.name,
    required this.cpf,
    required this.password,
  });

  final String name;
  final String cpf;
  final String password;
}
