import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/daily_closing_model.dart';

class DailyClosingRepository {
  DailyClosingRepository({
    required RestClient restClient,
    required Log log,
  })  : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  Future<void> register(DailyClosingModel dailyClosingModel) async {
    try {
      await _restClient.auth().post<Map<String, dynamic>>(
            '/daily-closing',
            data: dailyClosingModel.toMap(),
          );
    } on RestClientException catch (e, s) {
      _log.error('Erro ao fazer fechamento', e, s);
      throw Failure(message: 'Erro ao fazer fechamento');
    }
  }

  Future<List<DailyClosingModel>?> findAll() async {
    try {
      final response = await _restClient.auth().get<List<dynamic>>(
            '/daily-closing',
          );

      if (response.data != null) {
        final dailyClosingList = List<Map<String, dynamic>>.from(response.data!)
          ..sort(
            (a, b) => DateTime.parse(b['date'].toString())
                .compareTo(DateTime.parse(a['date'].toString())),
          );

        return dailyClosingList.map(DailyClosingModel.fromMap).toList();
      }

      return [];
    } on RestClientException catch (e, s) {
      _log.error('Erro ao buscar fechamento', e, s);
      throw Failure(message: 'Erro ao buscar fechamento');
    }
  }
}
