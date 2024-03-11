import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/parking_space_model.dart';

class ParkingSpaceRepository {
  ParkingSpaceRepository({
    required RestClient restClient,
    required Log log,
  })  : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  Future<List<ParkingSpaceModel>> findAll() async {
    try {
      final response = await _restClient.auth().get<List<dynamic>>(
            '/parking-space',
          );
      if (response.data != null) {
        final parkingSpaceList =
            List<Map<String, dynamic>>.from(response.data!);
        return parkingSpaceList.map(ParkingSpaceModel.fromMap).toList();
      }

      return [];
    } on RestClientException catch (e, s) {
      _log.error('Erro buscar vagas do estacionamento', e, s);
      throw Failure(message: 'Erro buscar vagas do estacionamento');
    }
  }

  Future<void> update({
    required int id,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _restClient.auth().put<Map<String, dynamic>>(
            '/parking-space/$id',
            data: data,
          );
    } on RestClientException catch (e, s) {
      _log.error('Erro atualizar vaga do estacionamento', e, s);
      throw Failure(message: 'Erro atualizar vaga do estacionamento');
    }
  }
}
