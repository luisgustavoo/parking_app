part of 'vehicles_bloc.dart';

sealed class VehiclesEvent extends Equatable {
  const VehiclesEvent();

  @override
  List<Object> get props => [];
}

class VehiclesFindAllEvent extends VehiclesEvent {}
