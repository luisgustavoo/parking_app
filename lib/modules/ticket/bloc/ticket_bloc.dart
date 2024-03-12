import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/ticket_model.dart';
import 'package:parking_app/modules/ticket/repository/ticket_repository.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc({
    required TicketRepository ticketRepository,
    required Log log,
  })  : _ticketRepository = ticketRepository,
        _log = log,
        super(TicketInitial()) {
    on<TicketFindByParkingSpaceIdEvent>(_findByParkingSpaceId);
    on<TicketFindAllEvent>(_findAll);
  }

  final TicketRepository _ticketRepository;
  final Log _log;

  Future<void> _findByParkingSpaceId(
    TicketFindByParkingSpaceIdEvent event,
    Emitter<TicketState> emit,
  ) async {
    try {
      emit(TicketLoading());
      final ticket = await _ticketRepository.findByParkingSpaceId(event.id);
      emit(TicketSuccess(ticket: ticket));
    } on Exception catch (e, s) {
      emit(TicketFailure());
      _log.error('Erro ao buscar ticket', e, s);
    }
  }

  Future<void> _findAll(
    TicketFindAllEvent event,
    Emitter<TicketState> emit,
  ) async {
    try {
      emit(TicketLoading());
      final ticketList = await _ticketRepository.findAll();
      emit(TicketSuccess(ticketList: ticketList));
    } on Exception catch (e, s) {
      emit(TicketFailure());
      _log.error('Erro ao buscar ticket', e, s);
    }
  }
}
