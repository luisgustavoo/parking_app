import 'package:flutter/widgets.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:parking_app/modules/auth/bloc/auth_bloc.dart';
import 'package:parking_app/modules/auth/page/login_page.dart';
import 'package:parking_app/modules/auth/page/register_page.dart';

class AuthModule extends FlutterGetItModule {
  @override
  List<Bind<Object>> get bindings {
    return [
      Bind.lazySingleton(
        (i) => AuthBloc(),
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
