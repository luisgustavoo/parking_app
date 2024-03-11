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

  Future<VehiclesModel?> update(VehiclesModel vehiclesModel) async {
    try {
      final response = await _restClient.auth().patch<Map<String, dynamic>>(
            '/vehicles/${vehiclesModel.id}',
            data: vehiclesModel.toMap(),
          );
      if (response.data != null) {
        return VehiclesModel.fromMap(response.data!);
      }

      return null;
    } on RestClientException catch (e, s) {
      _log.error('Erro ao atualizar veículo', e, s);
      throw Failure(message: 'Erro ao atualizar veículo');
    }
  }

  Future<void> delete(int id) async {
    try {
      await _restClient.auth().delete<Map<String, dynamic>>(
            '/vehicles/$id',
          );
    } on RestClientException catch (e, s) {
      _log.error('Erro ao excluir veículo', e, s);
      throw Failure(message: 'Erro ao excluir veículo');
    }
  }
}
