import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_app/core/exceptions/parking_not_data_found_exception.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/parking_model.dart';
import 'package:parking_app/modules/parking/repository/parking_repository.dart';

part 'parking_event.dart';
part 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  ParkingBloc({
    required ParkingRepository parkingRepository,
    required Log log,
  })  : _parkingRepository = parkingRepository,
        _log = log,
        super(ParkingInitial()) {
    on<ParkingFindAllEvent>(_findAll);
  }

  final ParkingRepository _parkingRepository;
  final Log _log;

  Future<void> _findAll(
    ParkingFindAllEvent event,
    Emitter<ParkingState> emit,
  ) async {
    try {
      emit(ParkingLoading());
      final parking = await _parkingRepository.findAll();
      if (parking == null) {
        throw ParkingNotDataFoundException();
      }
      emit(ParkingSuccess(parkingModel: parking));
    } on Exception catch (e, s) {
      emit(ParkingFailure());
      _log.error('Erro buscar dados do estacionamento', e, s);
    }
  }
}
