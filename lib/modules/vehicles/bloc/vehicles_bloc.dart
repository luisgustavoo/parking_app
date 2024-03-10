import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/vehicles_model.dart';
import 'package:parking_app/modules/vehicles/repository/vehicles_repository.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  VehiclesBloc({
    required VehiclesRepository vehiclesRepository,
    required Log log,
  })  : _vehiclesRepository = vehiclesRepository,
        _log = log,
        super(VehiclesInitial()) {
    on<VehiclesFindAllEvent>(_findAll);
    on<VehiclesRegisterEvent>(_register);
  }

  final VehiclesRepository _vehiclesRepository;
  final Log _log;

  Future<void> _findAll(
    VehiclesFindAllEvent event,
    Emitter<VehiclesState> emit,
  ) async {
    try {
      emit(VehiclesLoading());
      final vehiclesList = await _vehiclesRepository.findAll();
      emit(VehiclesSuccess(vehicleList: vehiclesList));
    } on Exception catch (e, s) {
      emit(VehiclesFailure(error: e));
      _log.error('Erro buscar lista veículos', e, s);
      throw Failure(message: 'Erro buscar lista veículos');
    }
  }

  Future<void> _register(
    VehiclesRegisterEvent event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(VehiclesLoading());
    emit(VehiclesLoading());
  }
}
