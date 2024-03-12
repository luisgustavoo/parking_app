part of 'payment_bloc.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

final class PaymentInitial extends PaymentState {}

final class PaymentSuccess extends PaymentState {}

final class PaymentLoading extends PaymentState {}

final class PaymentFailure extends PaymentState {}