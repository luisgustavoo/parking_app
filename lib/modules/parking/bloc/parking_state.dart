part of 'parking_bloc.dart';

sealed class ParkingState extends Equatable {
  const ParkingState();

  @override
  List<Object> get props => [];
}

final class ParkingInitial extends ParkingState {}

final class ParkingLoading extends ParkingState {}

final class ParkingSuccess extends ParkingState {
  const ParkingSuccess({
    required this.parkingModel,
  });

  final ParkingModel parkingModel;
}

final class ParkingFailure extends ParkingState {}
