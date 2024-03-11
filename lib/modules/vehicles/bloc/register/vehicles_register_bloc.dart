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
        super(VehiclesRegisterInitial()) {
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
      emit(VehiclesRegisterLoading());
      final vehicle = VehiclesModel(
        plate: event.plate,
        model: event.model,
        color: event.color,
        type: event.type,
        owner: event.owner,
      );
      await _vehiclesRegisterRepository.register(vehicle);
      emit(VehiclesRegisterSuccess());
    } on Exception catch (e, s) {
      emit(VehiclesRegisterFailure());
      _log.error('Erro buscar lista veículos', e, s);
    }
  }

  Future<void> _update(
    VehiclesUpdateEvent event,
    Emitter<VehiclesRegisterState> emit,
  ) async {
    try {
      emit(VehiclesRegisterLoading());
      await _vehiclesRegisterRepository.update(event.vehiclesModel);
      emit(VehiclesRegisterSuccess());
    } on Exception catch (e, s) {
      emit(VehiclesRegisterFailure());
      _log.error('Erro ao atualizar veículo', e, s);
    }
  }

  Future<void> _delete(
    VehiclesDeleteEvent event,
    Emitter<VehiclesRegisterState> emit,
  ) async {
    try {
      emit(VehiclesRegisterDeleting());
      await _vehiclesRegisterRepository.delete(event.id);
      emit(VehiclesRegisterDeletingSuccess());
    } on Exception catch (e, s) {
      emit(VehiclesRegisterDeletingFailure());
      _log.error('Erro ao deletar veículo', e, s);
    }
  }
}
