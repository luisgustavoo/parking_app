import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/rest_client/rest_client.dart';

class MockRestClient extends Mock implements RestClient {
  MockRestClient() {
    when(unAuth).thenReturn(this);
    when(auth).thenReturn(this);
  }
}
