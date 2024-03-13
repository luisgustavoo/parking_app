import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/models/payment_model.dart';
import 'package:parking_app/modules/payment/repository/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc({
    required PaymentRepository paymentRepository,
    required Log log,
  })  : _paymentRepository = paymentRepository,
        _log = log,
        super(const PaymentState.initial()) {
    on<PaymentRegisterEvent>(_register);
  }

  final PaymentRepository _paymentRepository;
  final Log _log;

  Future<void> _register(
    PaymentRegisterEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(state.copyWith(status: PaymentStatus.loading));
      await _paymentRepository.register(event.paymentModel);
      emit(state.copyWith(status: PaymentStatus.success));
    } on Exception catch (e, s) {
      emit(state.copyWith(
        status: PaymentStatus.failure,
        error: e,
      ));
      _log.error('Erro ao realizar pagamento', e, s);
    }
  }
}
