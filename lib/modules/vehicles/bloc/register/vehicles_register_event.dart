part of 'vehicles_register_bloc.dart';

sealed class VehiclesRegisterEvent extends Equatable {
  const VehiclesRegisterEvent();

  @override
  List<Object> get props => [];
}

class VehiclesRegisterVehicleEvent extends VehiclesRegisterEvent {
  const VehiclesRegisterVehicleEvent({
    required this.plate,
    required this.model,
    required this.color,
    required this.type,
    required this.owner,
  });

  final String plate;
  final String model;
  final String color;
  final VehiclesType type;
  final String owner;
}
