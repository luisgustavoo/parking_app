part of 'parking_space_bloc.dart';

sealed class ParkingSpaceEvent extends Equatable {
  const ParkingSpaceEvent();

  @override
  List<Object> get props => [];
}

class ParkingSpaceFindAllEvent extends ParkingSpaceEvent {}
