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
      final response = await _restClient.auth().post<Map<String, dynamic>>(
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

  Future<List<TicketModel>?> findAll() async {
    try {
      final response = await _restClient.auth().get<List<dynamic>>(
            '/ticket',
          );
      if (response.data != null) {
        final ticketList = List<Map<String, dynamic>>.from(response.data!)
          ..sort(
            (a, b) => DateTime.parse(a['entry_data_time'].toString())
                .compareTo(DateTime.parse(b['entry_data_time'].toString())),
          );
        return ticketList.map(TicketModel.fromMap).toList();
      }

      return null;
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar ticket', e, s);
      throw Failure(message: 'Erro ao buscar ticket');
    }
  }

  Future<TicketModel?> findByParkingSpaceId(int id) async {
    try {
      final response = await _restClient.auth().get<List<dynamic>>(
        '/ticket',
        queryParameters: {
          'parking_space_id': id,
          'departure_date_time': null,
        },
      );
      if (response.data != null) {
        final ticketList = List<Map<String, dynamic>>.from(response.data!)
          ..sort(
            (a, b) => DateTime.parse(a['entry_data_time'].toString())
                .compareTo(DateTime.parse(b['entry_data_time'].toString())),
          );
        return TicketModel.fromMap(ticketList.last);
      }

      return null;
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar ticket', e, s);
      throw Failure(message: 'Erro ao buscar ticket');
    }
  }

  Future<List<TicketModel>?> findByDate(DateTime date) async {
    try {
      final response = await _restClient.auth().get<List<dynamic>>(
        '/ticket',
        queryParameters: {
          'date': date.toLocal().toString(),
        },
      );
      if (response.data != null) {
        final ticketListSort = List<Map<String, dynamic>>.from(response.data!)
          ..sort(
            (a, b) => DateTime.parse(a['entry_data_time'].toString())
                .compareTo(DateTime.parse(b['entry_data_time'].toString())),
          );

        return ticketListSort.map(TicketModel.fromMap).toList();
      }

      return null;
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar ticket', e, s);
      throw Failure(message: 'Erro ao buscar ticket');
    }
  }

  Future<void> update(int id, Map<String, dynamic> data) async {
    try {
      await _restClient.auth().put<Map<String, dynamic>>(
            '/ticket/$id',
            data: data,
          );
    } on RestClientException catch (e, s) {
      _log.error('Erro ao atualizar ticket', e, s);
      throw Failure(message: 'Erro ao atualizar ticket');
    }
  }
}
