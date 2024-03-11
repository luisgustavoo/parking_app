import 'package:parking_app/core/exceptions/failure.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/models/vehicles_model.dart';

class VehiclesRegisterRepository {
  VehiclesRegisterRepository({
    required RestClient restClient,
    required Log log,
  })  : _restClient = restClient,
        _log = log;

  final RestClient _restClient;
  final Log _log;

  Future<VehiclesModel?> register(VehiclesModel vehiclesModel) async {
    try {
      final response = await _restClient.auth().post<Map<String, dynamic>>(
            '/vehicles',
            data: vehiclesModel.toMap(),
          );
      if (response.data != null) {
        return VehiclesModel.fromMap(response.data!);
      }

      return null;
    } on RestClientException catch (e, s) {
      _log.error('Erro register veículo', e, s);
      throw Failure(message: 'Erro register veículo');
    }
  }
}
