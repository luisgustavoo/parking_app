import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/rest_client/rest_client_response.dart';

class MockRestClientResponse<T> extends Mock implements RestClientResponse<T> {
  MockRestClientResponse({
    this.data,
    this.statusCode,
    this.statusMessage,
  });

  @override
  final T? data;
  @override
  final int? statusCode;
  @override
  final String? statusMessage;
}
