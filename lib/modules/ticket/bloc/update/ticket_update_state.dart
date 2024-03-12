part of 'ticket_update_bloc.dart';

sealed class TicketUpdateState extends Equatable {
  const TicketUpdateState();

  @override
  List<Object> get props => [];
}

final class TicketUpdateInitial extends TicketUpdateState {}

final class TicketUpdateLoading extends TicketUpdateState {}

final class TicketUpdateSuccess extends TicketUpdateState {}

final class TicketUpdateFailure extends TicketUpdateState {}
