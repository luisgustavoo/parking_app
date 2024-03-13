part of 'ticket_bloc.dart';

extension PatternMatch on TicketState {
  Widget match({
    required Widget Function() onInitial,
    required Widget Function() onLoading,
    required Widget Function() onSuccess,
    required Widget Function() onFailure,
  }) {
    switch (status) {
      case TicketStatus.initial:
        return onInitial();
      case TicketStatus.loading:
        return onLoading();
      case TicketStatus.success:
        return onSuccess();
      case TicketStatus.failure:
        return onFailure();
      default:
        return const SizedBox.shrink();
    }
  }
}

enum TicketStatus { initial, loading, success, failure }

class TicketState extends Equatable {
  const TicketState._({
    required this.status,
    this.ticketList,
    this.ticket,
    this.error,
  });

  TicketState.initial()
      : this._(
          status: TicketStatus.initial,
          ticketList: [],
        );

  final TicketStatus status;

  final List<TicketModel>? ticketList;

  final TicketModel? ticket;

  final Exception? error;

  @override
  List<Object?> get props => [status, ticketList, ticket];

  TicketState copyWith({
    TicketStatus? status,
    List<TicketModel>? ticketList,
    TicketModel? ticket,
    Exception? error,
  }) {
    return TicketState._(
      status: status ?? this.status,
      ticketList: ticketList ?? this.ticketList,
      ticket: ticket ?? this.ticket,
      error: error,
    );
  }
}
