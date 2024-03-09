// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  const AuthState._({
    required this.status,
    this.error,
  });

  const AuthState.initial()
      : this._(
          status: AuthStatus.initial,
        );

  final AuthStatus status;
  final Exception? error;

  @override
  List<Object?> get props => [
        status,
        error,
      ];

  AuthState copyWith({
    AuthStatus? status,
    Exception? error,
  }) {
    return AuthState._(
      status: status ?? this.status,
      error: error,
    );
  }
}
