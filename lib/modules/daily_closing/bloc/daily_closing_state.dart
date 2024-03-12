part of 'daily_closing_bloc.dart';

extension PatternMatch on DailyClosingState {
  Widget match({
    required Widget Function() onInitial,
    required Widget Function() onLoading,
    required Widget Function(List<DailyClosingModel>? dailyClosingList)
        onSuccess,
    required Widget Function() onFailure,
  }) {
    final state = this;

    switch (state) {
      case DailyClosingInitial():
        return onInitial();
      case DailyClosingLoading():
        return onLoading();
      case DailyClosingSuccess():
        return onSuccess(state.dailyClosingList);
      case DailyClosingFailure():
        return onFailure();
      default:
        return const SizedBox.shrink();
    }
  }
}

sealed class DailyClosingState extends Equatable {
  const DailyClosingState();

  @override
  List<Object> get props => [];
}

final class DailyClosingInitial extends DailyClosingState {}

final class DailyClosingLoading extends DailyClosingState {}

final class DailyClosingSuccess extends DailyClosingState {
  const DailyClosingSuccess({
    this.dailyClosingList,
  });
  final List<DailyClosingModel>? dailyClosingList;
}

final class DailyClosingFailure extends DailyClosingState {}
