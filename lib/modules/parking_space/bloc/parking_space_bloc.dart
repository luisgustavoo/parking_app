import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/parking_space_model.dart';
import 'package:parking_app/modules/parking_space/repository/parking_space_repository.dart';

part 'parking_space_event.dart';
part 'parking_space_state.dart';

class ParkingSpaceBloc extends Bloc<ParkingSpaceEvent, ParkingSpaceState> {
  ParkingSpaceBloc({
    required ParkingSpaceRepository parkingSpaceRepository,
    required Log log,
  })  : _parkingSpaceRepository = parkingSpaceRepository,
        _log = log,
        super(const ParkingSpaceState.initial()) {
    on<ParkingSpaceFindAllEvent>(_findAll);
    on<ParkingSpaceUpdateEvent>(_update);
  }

  final ParkingSpaceRepository _parkingSpaceRepository;
  final Log _log;

  Future<void> _findAll(
    ParkingSpaceFindAllEvent event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: ParkingSpaceStatus.loading,
        ),
      );
      final parkingSpaceList = await _parkingSpaceRepository.findAll();
      emit(
        state.copyWith(
          status: ParkingSpaceStatus.success,
          parkingSpaceList: parkingSpaceList,
        ),
      );
    } on Exception catch (e, s) {
      emit(
        state.copyWith(
          status: ParkingSpaceStatus.failure,
          error: e,
        ),
      );
      _log.error('Erro buscar vagas do estacionamento', e, s);
    }
  }

  Future<void> _update(
    ParkingSpaceUpdateEvent event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    try {
      await _parkingSpaceRepository.update(id: event.id, data: event.data);
    } on Exception catch (e, s) {
      emit(
        state.copyWith(
          status: ParkingSpaceStatus.failure,
        ),
      );
      _log.error('Erro ao atualizar vaga do estacionamento', e, s);
    }
  }
}
