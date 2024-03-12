part of 'ticket_bloc.dart';

extension PatternMatch on TicketState {
  Widget match({
    required Widget Function() onInitial,
    required Widget Function() onLoading,
    required Widget Function({
      List<TicketModel>? ticketList,
      TicketModel? ticket,
    }) onSuccess,
    required Widget Function() onFailure,
  }) {
    final state = this;

    switch (state) {
      case TicketInitial():
        return onInitial();
      case TicketLoading():
        return onLoading();
      case TicketSuccess():
        return onSuccess(
          ticket: state.ticket,
          ticketList: state.ticketList,
        );
      case TicketFailure():
        return onFailure();
      default:
        return const SizedBox.shrink();
    }
  }
}

sealed class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object> get props => [];
}

final class TicketInitial extends TicketState {}

final class TicketLoading extends TicketState {}

final class TicketSuccess extends TicketState {
  const TicketSuccess({
    this.ticketList,
    this.ticket,
  });

  final List<TicketModel>? ticketList;
  final TicketModel? ticket;
}

final class TicketFailure extends TicketState {}
