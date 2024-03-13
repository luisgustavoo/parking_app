// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'payment_bloc.dart';

enum PaymentStatus { initial, loading, success, failure }

class PaymentState extends Equatable {
  const PaymentState._({
    required this.status,
    this.error,
  });

  const PaymentState.initial() : this._(status: PaymentStatus.initial);

  final PaymentStatus status;
  final Exception? error;

  @override
  List<Object?> get props => [status, error];

  PaymentState copyWith({
    PaymentStatus? status,
    Exception? error,
  }) {
    return PaymentState._(
      status: status ?? this.status,
      error: error,
    );
  }
}
