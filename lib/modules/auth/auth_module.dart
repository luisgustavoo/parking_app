import 'package:flutter/widgets.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:parking_app/modules/auth/bloc/auth_bloc.dart';
import 'package:parking_app/modules/auth/page/login_page.dart';
import 'package:parking_app/modules/auth/page/register_page.dart';
import 'package:parking_app/modules/auth/repository/auth_repository.dart';
import 'package:parking_app/modules/auth/service/auth_service.dart';

class AuthModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings {
    return [
      Bind.lazySingleton(
        (i) => AuthRepository(
          restClient: i(),
          log: i(),
        ),
      ),
      Bind.lazySingleton(
        (i) => AuthService(
          authRepository: i(),
          localStorage: i(),
          localSecurityStorage: i(),
          log: i(),
        ),
      ),
      Bind.lazySingleton(
        (i) => AuthBloc(authService: i(), log: i()),
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
