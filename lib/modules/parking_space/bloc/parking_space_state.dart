// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'parking_space_bloc.dart';

extension PatternMatch on ParkingSpaceState {
  Widget match({
    required Widget Function() onInitial,
    required Widget Function() onLoading,
    required Widget Function() onSuccess,
    required Widget Function() onFailure,
  }) {
    switch (status) {
      case ParkingSpaceStatus.initial:
        return onInitial();
      case ParkingSpaceStatus.loading:
        return onLoading();
      case ParkingSpaceStatus.success:
        return onSuccess();
      case ParkingSpaceStatus.failure:
        return onFailure();
      default:
        return const SizedBox.shrink();
    }
  }
}

enum ParkingSpaceStatus { initial, loading, success, failure }

class ParkingSpaceState extends Equatable {
  const ParkingSpaceState._({
    required this.status,
    this.parkingSpaceList,
    this.error,
  });

  const ParkingSpaceState.initial()
      : this._(status: ParkingSpaceStatus.initial);

  final ParkingSpaceStatus status;
  final List<ParkingSpaceModel>? parkingSpaceList;
  final Exception? error;

  @override
  List<Object?> get props => [status, parkingSpaceList, error];

  ParkingSpaceState copyWith({
    ParkingSpaceStatus? status,
    List<ParkingSpaceModel>? parkingSpaceList,
    Exception? error,
  }) {
    return ParkingSpaceState._(
      status: status ?? this.status,
      parkingSpaceList: parkingSpaceList ?? this.parkingSpaceList,
      error: error,
    );
  }
}
