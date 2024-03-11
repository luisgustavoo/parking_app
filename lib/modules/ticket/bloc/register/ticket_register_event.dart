part of 'ticket_register_bloc.dart';

sealed class TicketRegisterEvent extends Equatable {
  const TicketRegisterEvent();

  @override
  List<Object> get props => [];
}

class TicketRegisterTicketEvent extends TicketRegisterEvent {
  const TicketRegisterTicketEvent({
    required this.ticketModel,
  });

  final TicketModel ticketModel;
}
