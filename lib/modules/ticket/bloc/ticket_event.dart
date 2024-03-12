// ignore_for_file: public_member_api_docs, sort_constructors_first
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

class TicketFindByDateEvent extends TicketEvent {
  const TicketFindByDateEvent({
    required this.date,
  });
  final DateTime date;
}
