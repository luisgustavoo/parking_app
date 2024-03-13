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
        super(TicketState.initial()) {
    on<TicketFindByParkingSpaceIdEvent>(_findByParkingSpaceId);
    on<TicketFindAllEvent>(_findAll);
    on<TicketFindByDateEvent>(_findByDate);
  }

  final TicketRepository _ticketRepository;
  final Log _log;
  List<TicketModel>? ticketList = [];
  DateTime? filteredDate;

  Future<void> _findByParkingSpaceId(
    TicketFindByParkingSpaceIdEvent event,
    Emitter<TicketState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TicketStatus.loading));
      final ticket = await _ticketRepository.findByParkingSpaceId(event.id);
      emit(
        state.copyWith(
          status: TicketStatus.success,
          ticket: ticket,
        ),
      );
    } on Exception catch (e, s) {
      emit(
        state.copyWith(
          status: TicketStatus.failure,
          error: e,
        ),
      );
      _log.error('Erro ao buscar ticket', e, s);
    }
  }

  Future<void> _findAll(
    TicketFindAllEvent event,
    Emitter<TicketState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TicketStatus.loading));
      ticketList = await _ticketRepository.findAll();
      emit(
        state.copyWith(
          status: TicketStatus.success,
          ticketList: ticketList,
        ),
      );
    } on Exception catch (e, s) {
      emit(
        state.copyWith(
          status: TicketStatus.failure,
          error: e,
        ),
      );
      _log.error('Erro ao buscar ticket', e, s);
    }
  }

  Future<void> _findByDate(
    TicketFindByDateEvent event,
    Emitter<TicketState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TicketStatus.loading));
      filteredDate = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
      );
      ticketList = await _ticketRepository.findByDate(filteredDate!);
      emit(
        state.copyWith(
          status: TicketStatus.success,
          ticketList: ticketList,
        ),
      );
    } on Exception catch (e, s) {
      emit(
        state.copyWith(
          status: TicketStatus.failure,
          error: e,
        ),
      );
      _log.error('Erro ao buscar ticket', e, s);
    }
  }
}
