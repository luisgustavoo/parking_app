import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/modules/ticket/repository/ticket_repository.dart';

part 'ticket_update_event.dart';
part 'ticket_update_state.dart';

class TicketUpdateBloc extends Bloc<TicketUpdateEvent, TicketUpdateState> {
  TicketUpdateBloc({
    required TicketRepository ticketRepository,
    required Log log,
  })  : _ticketRepository = ticketRepository,
        _log = log,
        super(TicketUpdateInitial()) {
    on<TicketUpdateUpdateTicketEvent>(_update);
  }

  final TicketRepository _ticketRepository;
  final Log _log;

  Future<void> _update(
    TicketUpdateUpdateTicketEvent event,
    Emitter<TicketUpdateState> emit,
  ) async {
    try {
      emit(TicketUpdateLoading());
      await _ticketRepository.update(
        event.id,
        event.data,
      );
      emit(TicketUpdateSuccess());
    } on Exception catch (e, s) {
      emit(TicketUpdateFailure());
      _log.error('Erro atualizar ticket', e, s);
    }
  }
}
