import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';
import 'package:parking_app/modules/auth/repository/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {
  MockAuthRepository({
    required this.restClient,
    required this.log,
  });

  final RestClient restClient;
  final Log log;
}
