part of 'vehicles_bloc.dart';

extension PatternMatch on VehiclesState {
  Widget match({
    required Widget Function() onInitial,
    required Widget Function() onLoading,
    required Widget Function(List<VehiclesModel> vehicleList) onSuccess,
    required Widget Function() onFailure,
  }) {
    final state = this;

    switch (state) {
      case VehiclesInitial():
        return onInitial();
      case VehiclesLoading():
        return onLoading();
      case VehiclesSuccess():
        return onSuccess(state.vehicleList);
      case VehiclesFailure():
        return onFailure();
      default:
        return const SizedBox.shrink();
    }
  }
}

sealed class VehiclesState extends Equatable {
  const VehiclesState();

  @override
  List<Object> get props => [];
}

final class VehiclesInitial extends VehiclesState {}

final class VehiclesLoading extends VehiclesState {}

final class VehiclesSuccess extends VehiclesState {
  const VehiclesSuccess({
    required this.vehicleList,
  });
  final List<VehiclesModel> vehicleList;
}

final class VehiclesFailure extends VehiclesState {
  const VehiclesFailure({
    required this.error,
  });

  final Exception error;
}
