part of 'ticket_update_bloc.dart';

sealed class TicketUpdateEvent extends Equatable {
  const TicketUpdateEvent();

  @override
  List<Object> get props => [];
}

class TicketUpdateUpdateTicketEvent extends TicketUpdateEvent {
  const TicketUpdateUpdateTicketEvent({
    required this.id,
    required this.data,
  });

  final int id;
  final Map<String, dynamic> data;
}
