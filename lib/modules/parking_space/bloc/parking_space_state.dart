part of 'parking_space_bloc.dart';

extension PatternMatch on ParkingSpaceState {
  Widget match({
    required Widget Function() onInitial,
    required Widget Function() onLoading,
    required Widget Function(List<ParkingSpaceModel> vehicleList) onSuccess,
    required Widget Function() onFailure,
  }) {
    final state = this;

    switch (state) {
      case ParkingSpaceInitial():
        return onInitial();
      case ParkingSpaceLoading():
        return onLoading();
      case ParkingSpaceSuccess():
        return onSuccess(state.parkingSpaceList);
      case ParkingSpaceFailure():
        return onFailure();
      default:
        return const SizedBox.shrink();
    }
  }
}

sealed class ParkingSpaceState extends Equatable {
  const ParkingSpaceState();

  @override
  List<Object> get props => [];
}

final class ParkingSpaceInitial extends ParkingSpaceState {}

final class ParkingSpaceLoading extends ParkingSpaceState {}

final class ParkingSpaceSuccess extends ParkingSpaceState {
  const ParkingSpaceSuccess({
    required this.parkingSpaceList,
  });

  final List<ParkingSpaceModel> parkingSpaceList;
}

final class ParkingSpaceFailure extends ParkingSpaceState {}
