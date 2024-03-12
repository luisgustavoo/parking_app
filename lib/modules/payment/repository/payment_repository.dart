import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/payment_model.dart';

class PaymentRepository {
  PaymentRepository({
    required RestClient restClient,
    required Log log,
  })  : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  Future<void> register(PaymentModel paymentModel) async {
    try {
      await _restClient.auth().post<Map<String, dynamic>>(
            '/payment',
            data: paymentModel.toMap(),
          );
    } on RestClientException catch (e, s) {
      _log.error('Erro ao registra pagamento', e, s);
      throw Failure(message: 'Erro ao registra pagamento');
    }
  }
}
