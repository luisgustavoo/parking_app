part of 'parking_bloc.dart';

enum ParkingStatus { initial, loading, success, failure }

class ParkingState extends Equatable {
  const ParkingState._({
    required this.status,
    this.parkingModel,
    this.error,
  });

  const ParkingState.initial() : this._(status: ParkingStatus.initial);

  final ParkingStatus status;
  final ParkingModel? parkingModel;
  final Exception? error;

  @override
  List<Object?> get props => [status, parkingModel, error];

  ParkingState copyWith({
    ParkingStatus? status,
    ParkingModel? parkingModel,
    Exception? error,
  }) {
    return ParkingState._(
      status: status ?? this.status,
      parkingModel: parkingModel ?? this.parkingModel,
      error: error,
    );
  }
}
