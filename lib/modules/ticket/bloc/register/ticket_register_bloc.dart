import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/ticket_model.dart';
import 'package:parking_app/modules/ticket/repository/ticket_repository.dart';

part 'ticket_register_event.dart';
part 'ticket_register_state.dart';

class TicketRegisterBloc
    extends Bloc<TicketRegisterEvent, TicketRegisterState> {
  TicketRegisterBloc({
    required TicketRepository ticketRepository,
    required Log log,
  })  : _ticketRepository = ticketRepository,
        _log = log,
        super(TicketRegisterInitial()) {
    on<TicketRegisterTicketEvent>(_register);
  }

  final TicketRepository _ticketRepository;
  final Log _log;

  Future<void> _register(
    TicketRegisterTicketEvent event,
    Emitter<TicketRegisterState> emit,
  ) async {
    try {
      emit(TicketRegisterLoading());
      await _ticketRepository.register(event.ticketModel);
      emit(TicketRegisterSuccess());
    } on Exception catch (e, s) {
      emit(TicketRegisterFailure());
      _log.error('Erro register ticket', e, s);
    }
  }
}
