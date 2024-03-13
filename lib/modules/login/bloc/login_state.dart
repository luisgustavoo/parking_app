// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState._({
    required this.status,
    this.error,
  });

  const LoginState.initial() : this._(status: LoginStatus.initial);

  final LoginStatus status;
  final Exception? error;

  @override
  List<Object?> get props => [status, error];

  LoginState copyWith({
    LoginStatus? status,
    Exception? error,
  }) {
    return LoginState._(
      status: status ?? this.status,
      error: error,
    );
  }
}
