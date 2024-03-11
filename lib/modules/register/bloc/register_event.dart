part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends RegisterEvent {
  const RegisterUserEvent({
    required this.name,
    required this.cpf,
    required this.password,
  });

  final String name;
  final String cpf;
  final String password;
}
