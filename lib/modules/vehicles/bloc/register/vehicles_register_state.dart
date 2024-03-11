part of 'vehicles_register_bloc.dart';

sealed class VehiclesRegisterState extends Equatable {
  const VehiclesRegisterState();

  @override
  List<Object> get props => [];
}

final class VehiclesRegisterInitial extends VehiclesRegisterState {}

final class VehiclesRegisterLoading extends VehiclesRegisterState {}

final class VehiclesRegisterSuccess extends VehiclesRegisterState {}

final class VehiclesRegisterFailure extends VehiclesRegisterState {}

final class VehiclesRegisterDeleting extends VehiclesRegisterState {}

final class VehiclesRegisterDeletingSuccess extends VehiclesRegisterState {}

final class VehiclesRegisterDeletingFailure extends VehiclesRegisterState {}
