import 'package:flutter/widgets.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/modules/auth/auth_module.dart';
import 'package:parking_app/modules/auth/bloc/auth_bloc.dart';
import 'package:parking_app/modules/auth/page/login_page.dart';
import 'package:parking_app/modules/auth/page/register_page.dart';
import 'package:parking_app/modules/auth/repository/auth_repository.dart';
import 'package:parking_app/modules/auth/service/auth_service.dart';

import 'mock_auth_bloc.dart';
import 'mock_auth_repository.dart';
import 'mock_auth_service.dart';

class MockAuthModule extends Mock implements AuthModule {
  @override
  List<Bind<Object>> get bindings {
    return [
      Bind.lazySingleton<AuthRepository>(
        (i) => MockAuthRepository(
          restClient: i(),
          log: i(),
        ),
      ),
      Bind.lazySingleton<AuthService>(
        (i) => MockAuthService(
          authRepository: i(),
          localStorage: i(),
          localSecurityStorage: i(),
          log: i(),
        ),
      ),
      Bind.lazySingleton<AuthBloc>(
        (i) => MockAuthBloc(authService: i(), log: i()),
      ),
    ];
  }

  @override
  String get moduleRouteName => '/auth';

  @override
  Map<String, WidgetBuilder> get pages {
    return {
      '/register': (context) => const RegisterPage(),
      '/login': (context) => const LoginPage(),
    };
  }
}
