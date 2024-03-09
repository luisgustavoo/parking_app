import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/rest_client/rest_client_exception.dart';
import 'package:parking_app/core/rest_client/rest_client_response.dart';

class MockRestClientException extends Mock implements RestClientException {
  MockRestClientException({
    this.message,
    this.statusCode,
    this.response,
  });

  @override
  final String? message;
  @override
  final int? statusCode;
  @override
  final RestClientResponse<dynamic>? response;
}
