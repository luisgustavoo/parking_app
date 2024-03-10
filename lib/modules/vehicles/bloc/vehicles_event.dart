part of 'vehicles_bloc.dart';

sealed class VehiclesEvent extends Equatable {
  const VehiclesEvent();

  @override
  List<Object> get props => [];
}

class VehiclesFindAllEvent extends VehiclesEvent {}

class VehiclesRegisterEvent extends VehiclesEvent {
  const VehiclesRegisterEvent({
    required this.plate,
    required this.model,
    required this.color,
    required this.type,
    required this.owner,
  });

  final String plate;
  final String model;
  final String color;
  final String type;
  final String owner;
}
