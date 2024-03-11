import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/parking_model.dart';

class ParkingRepository {
  ParkingRepository({
    required RestClient restClient,
    required Log log,
  })  : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  Future<ParkingModel?> findAll() async {
    try {
      final response = await _restClient.auth().get<List<dynamic>>(
            '/parking',
          );
      if (response.data != null) {
        final parkingList = List<Map<String, dynamic>>.from(response.data!);
        return ParkingModel.fromMap(parkingList.first);
      }

      return null;
    } on RestClientException catch (e, s) {
      _log.error('Erro buscar dados do estacionamento', e, s);
      throw Failure(message: 'Erro buscar dados do estacionamento');
    }
  }
}
