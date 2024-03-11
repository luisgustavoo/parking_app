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
}
