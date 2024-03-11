part of 'parking_space_bloc.dart';

sealed class ParkingSpaceEvent extends Equatable {
  const ParkingSpaceEvent();

  @override
  List<Object> get props => [];
}

class ParkingSpaceFindAllEvent extends ParkingSpaceEvent {}

class ParkingSpaceUpdateEvent extends ParkingSpaceEvent {
  const ParkingSpaceUpdateEvent({
    required this.id,
    required this.data,
  });

  final int id;
  final Map<String, dynamic> data;
}
