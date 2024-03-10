import 'package:bloc_test/bloc_test.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/modules/auth/bloc/auth_bloc.dart';
import 'package:parking_app/modules/auth/service/auth_service.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {
  MockAuthBloc({
    required this.authService,
    required this.log,
  });
  final AuthService authService;
  final Log log;
}
