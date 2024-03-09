import 'package:mocktail/mocktail.dart';
import 'package:parking_app/modules/auth/bloc/auth_bloc.dart';

class MockAuthState extends Mock implements AuthState {
  MockAuthState({
    this.status,
    this.error,
  });
  @override
  final AuthStatus? status;
  @override
  final Exception? error;
}
