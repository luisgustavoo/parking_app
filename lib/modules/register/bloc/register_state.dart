part of 'register_bloc.dart';

enum RegisterStatus { initial, loading, success, failure }

class RegisterState extends Equatable {
  const RegisterState._({
    required this.status,
    this.error,
  });

  const RegisterState.initial() : this._(status: RegisterStatus.initial);

  final RegisterStatus status;
  final Exception? error;

  @override
  List<Object?> get props => [status, error];

  RegisterState copyWith({
    RegisterStatus? status,
    Exception? error,
  }) {
    return RegisterState._(
      status: status ?? this.status,
      error: error,
    );
  }
}
