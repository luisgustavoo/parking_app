import 'package:mocktail/mocktail.dart';
import 'package:parking_app/core/rest_client/logs/log.dart';
import 'package:parking_app/modules/auth/bloc/auth_bloc.dart';
import 'package:parking_app/modules/auth/service/auth_service.dart';

import 'mock_auth_state.dart';

class MockAuthBloc extends Mock implements AuthBloc {
  MockAuthBloc({
    required this.authService,
    required this.log,
  });

  final AuthService authService;
  final Log log;
}
