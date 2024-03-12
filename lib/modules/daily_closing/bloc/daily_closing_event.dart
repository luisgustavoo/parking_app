part of 'daily_closing_bloc.dart';

sealed class DailyClosingEvent extends Equatable {
  const DailyClosingEvent();

  @override
  List<Object> get props => [];
}

class DailyClosingRegisterEvent extends DailyClosingEvent {
  const DailyClosingRegisterEvent({
    required this.ticketList,
  });
  final List<TicketModel>? ticketList;
}

class DailyClosingFindAllEvent extends DailyClosingEvent {}
