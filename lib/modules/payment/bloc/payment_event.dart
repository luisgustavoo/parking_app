part of 'payment_bloc.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentRegisterEvent extends PaymentEvent {
  const PaymentRegisterEvent({
    required this.paymentModel,
  });

  final PaymentModel paymentModel;
}
