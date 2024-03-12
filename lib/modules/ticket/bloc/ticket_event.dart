part of 'ticket_bloc.dart';

sealed class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object> get props => [];
}

class TicketFindByParkingSpaceIdEvent extends TicketEvent {
  const TicketFindByParkingSpaceIdEvent({
    required this.id,
  });

  final int id;
}

class TicketFindAllEvent extends TicketEvent {}
