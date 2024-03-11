part of 'ticket_register_bloc.dart';

sealed class TicketRegisterState extends Equatable {
  const TicketRegisterState();

  @override
  List<Object> get props => [];
}

final class TicketRegisterInitial extends TicketRegisterState {}

final class TicketRegisterLoading extends TicketRegisterState {}

final class TicketRegisterSuccess extends TicketRegisterState {}

final class TicketRegisterFailure extends TicketRegisterState {}
