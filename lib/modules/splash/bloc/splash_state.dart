// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'splash_bloc.dart';

enum SplashStatus { initial, loading, success, failure }

class SplashState extends Equatable {
  const SplashState._({
    required this.status,
  });

  const SplashState.initial() : this._(status: SplashStatus.initial);

  final SplashStatus status;

  @override
  List<Object?> get props => [status];

  SplashState copyWith({
    SplashStatus? status,
  }) {
    return SplashState._(
      status: status ?? this.status,
    );
  }
}
