part of 'daily_closing_bloc.dart';

sealed class DailyClosingEvent extends Equatable {
  const DailyClosingEvent();

  @override
  List<Object> get props => [];
}

class DailyClosingRegisterEvent extends DailyClosingEvent {
  const DailyClosingRegisterEvent({
    required this.ticketList,
    required this.filteredDate,
  });
  final List<TicketModel> ticketList;
  final DateTime filteredDate;
}

class DailyClosingFindAllEvent extends DailyClosingEvent {}
