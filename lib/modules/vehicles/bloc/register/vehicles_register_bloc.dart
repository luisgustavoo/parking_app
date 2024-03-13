import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/vehicles_model.dart';
import 'package:parking_app/modules/vehicles/repository/vehicles_register_repository.dart';

part 'vehicles_register_event.dart';
part 'vehicles_register_state.dart';

class VehiclesRegisterBloc
    extends Bloc<VehiclesRegisterEvent, VehiclesRegisterState> {
  VehiclesRegisterBloc({
    required VehiclesRegisterRepository vehiclesRegisterRepository,
    required Log log,
  })  : _vehiclesRegisterRepository = vehiclesRegisterRepository,
        _log = log,
        super(const VehiclesRegisterState.initial()) {
    on<VehiclesRegisterVehicleEvent>(_register);
    on<VehiclesUpdateEvent>(_update);
    on<VehiclesDeleteEvent>(_delete);
  }

  final VehiclesRegisterRepository _vehiclesRegisterRepository;
  final Log _log;

  Future<void> _register(
    VehiclesRegisterVehicleEvent event,
    Emitter<VehiclesRegisterState> emit,
  ) async {
    try {
      emit(state.copyWith(status: VehiclesRegisterStatus.loading));
      final vehicle = VehiclesModel(
        plate: event.plate,
        model: event.model,
        color: event.color,
        type: event.type,
        owner: event.owner,
      );
      await _vehiclesRegisterRepository.register(vehicle);
      emit(state.copyWith(status: VehiclesRegisterStatus.success));
    } on Exception catch (e, s) {
      emit(
        state.copyWith(
          status: VehiclesRegisterStatus.failure,
          error: e,
        ),
      );
      _log.error('Erro buscar lista veículos', e, s);
    }
  }

  Future<void> _update(
    VehiclesUpdateEvent event,
    Emitter<VehiclesRegisterState> emit,
  ) async {
    try {
      emit(state.copyWith(status: VehiclesRegisterStatus.loading));
      await _vehiclesRegisterRepository.update(event.vehiclesModel);
      emit(state.copyWith(status: VehiclesRegisterStatus.success));
    } on Exception catch (e, s) {
      emit(state.copyWith(status: VehiclesRegisterStatus.failure));
      _log.error('Erro ao atualizar veículo', e, s);
    }
  }

  Future<void> _delete(
    VehiclesDeleteEvent event,
    Emitter<VehiclesRegisterState> emit,
  ) async {
    try {
      emit(state.copyWith(status: VehiclesRegisterStatus.loading));
      await _vehiclesRegisterRepository.delete(event.id);
      emit(state.copyWith(status: VehiclesRegisterStatus.success));
    } on Exception catch (e, s) {
      emit(state.copyWith(status: VehiclesRegisterStatus.failure));
      _log.error('Erro ao deletar veículo', e, s);
    }
  }
}
