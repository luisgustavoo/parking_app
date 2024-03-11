import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/ticket_model.dart';

class TicketRepository {
  TicketRepository({
    required RestClient restClient,
    required Log log,
  })  : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  Future<TicketModel?> register(TicketModel ticketModel) async {
    try {
      final response = await _restClient.unAuth().post<Map<String, dynamic>>(
            '/ticket',
            data: ticketModel.toMap(),
          );
      if (response.data != null) {
        return TicketModel.fromMap(Map.from(response.data!));
      }

      return null;
    } on RestClientException catch (e, s) {
      _log.error('Erro ao registra ticket', e, s);
      throw Failure(message: 'Erro ao registra ticket');
    }
  }
}
