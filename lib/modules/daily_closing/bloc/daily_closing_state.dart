part of 'daily_closing_bloc.dart';

extension PatternMatch on DailyClosingState {
  Widget match({
    required Widget Function() onInitial,
    required Widget Function() onLoading,
    required Widget Function() onSuccess,
    required Widget Function() onFailure,
  }) {
    switch (status) {
      case DailyClosingStatus.initial:
        return onInitial();
      case DailyClosingStatus.loading:
        return onLoading();
      case DailyClosingStatus.success:
        return onSuccess();
      case DailyClosingStatus.failure:
        return onFailure();
      default:
        return const SizedBox.shrink();
    }
  }
}

enum DailyClosingStatus { initial, loading, success, failure }

class DailyClosingState extends Equatable {
  const DailyClosingState._({
    required this.status,
    this.dailyClosingList,
    this.error,
  });

  DailyClosingState.initial()
      : this._(
          status: DailyClosingStatus.initial,
          dailyClosingList: [],
        );

  final DailyClosingStatus status;
  final List<DailyClosingModel>? dailyClosingList;
  final Exception? error;

  @override
  List<Object?> get props => [status, dailyClosingList, error];

  DailyClosingState copyWith({
    DailyClosingStatus? status,
    List<DailyClosingModel>? dailyClosingList,
    Exception? error,
  }) {
    return DailyClosingState._(
      status: status ?? this.status,
      dailyClosingList: dailyClosingList ?? this.dailyClosingList,
      error: error,
    );
  }
}
