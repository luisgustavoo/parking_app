// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'vehicles_bloc.dart';

extension PatternMatch on VehiclesState {
  Widget match({
    required Widget Function() onInitial,
    required Widget Function() onLoading,
    required Widget Function() onSuccess,
    required Widget Function() onFailure,
  }) {
    switch (status) {
      case VehiclesStatus.initial:
        return onInitial();
      case VehiclesStatus.loading:
        return onLoading();
      case VehiclesStatus.success:
        return onSuccess();
      case VehiclesStatus.failure:
        return onFailure();
      default:
        return const SizedBox.shrink();
    }
  }
}

enum VehiclesStatus { initial, loading, success, failure }

class VehiclesState extends Equatable {
  const VehiclesState._({
    required this.status,
    this.vehicleList,
    this.error,
  });

  VehiclesState.initial()
      : this._(
          status: VehiclesStatus.initial,
          vehicleList: [],
        );

  final VehiclesStatus status;
  final List<VehiclesModel>? vehicleList;
  final Exception? error;

  @override
  List<Object?> get props => [status, vehicleList, error];

  VehiclesState copyWith({
    VehiclesStatus? status,
    List<VehiclesModel>? vehicleList,
    Exception? error,
  }) {
    return VehiclesState._(
      status: status ?? this.status,
      vehicleList: vehicleList ?? this.vehicleList,
      error: error,
    );
  }
}
