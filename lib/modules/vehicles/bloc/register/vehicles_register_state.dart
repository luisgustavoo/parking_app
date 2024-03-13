// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'vehicles_register_bloc.dart';

enum VehiclesRegisterStatus {
  initial,
  loading,
  success,
  failure,
  deleting,
  deletingSuccess,
  deletingFailure,
}

class VehiclesRegisterState extends Equatable {
  const VehiclesRegisterState._({
    required this.status,
    this.error,
  });

  const VehiclesRegisterState.initial()
      : this._(status: VehiclesRegisterStatus.initial);

  final VehiclesRegisterStatus status;
  final Exception? error;

  @override
  List<Object?> get props => [status, error];

  VehiclesRegisterState copyWith({
    VehiclesRegisterStatus? status,
    Exception? error,
  }) {
    return VehiclesRegisterState._(
      status: status ?? this.status,
      error: error,
    );
  }
}
