import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/modules/auth/bloc/auth_bloc.dart';

import '../test/core/mocks/bindings/mock_application_binding.dart';
import '../test/modules/auth/mocks/mock_auth_bloc.dart';
import '../test/modules/auth/mocks/mock_auth_module.dart';
import '../test/modules/auth/mocks/mock_auth_repository.dart';
import '../test/modules/auth/mocks/mock_auth_service.dart';
import '../test/modules/auth/mocks/mock_auth_state.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();

  Widget createRegisterPage() {
    return Builder(
      builder: (ctx) {
        ScreenUtil.init(ctx);
        return FlutterGetIt(
          modules: [MockAuthModule()],
          bindings: MockApplicationBinding(),
          builder: (context, routes, flutterGetItNavObserver) {
            return MaterialApp(
              title: 'Parking',
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('pt', 'BR'),
              ],
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              navigatorObservers: [flutterGetItNavObserver],
              initialRoute: '/auth/register',
              routes: routes,
            );
          },
        );
      },
    );
  }

  setUp(() {
    // when(() => Injector.get()).thenReturn(
    //   Injector.get<MockAuthBloc>(),
    // );
    registerFallbackValue(MockAuthState());
  });

  testWidgets('Test if register page shows up', (tester) async {
    await tester.pumpWidget(createRegisterPage());

    final bloc = Injector.get<AuthBloc>();

    await Future<void>.delayed(const Duration(seconds: 3));

    //Assert
    // expect(find.widgetWithText(Text, 'Cadastrar'), findsOneWidget);
    // expect(
    //   find.widgetWithText(TextFormField, 'CPF'),
    //   findsOneWidget,
    // );
    // expect(find.widgetWithText(TextFormField, 'Nome'), findsOneWidget);
    // expect(find.widgetWithText(TextFormField, 'Senha'), findsOneWidget);
    // expect(
    //   find.widgetWithText(TextFormField, 'Confirmar senha'),
    //   findsOneWidget,
    // );

    // expect(
    //   find.byType(
    //     ElevatedButton,
    //   ),
    //   findsOneWidget,
    // );

    // expect(find.widgetWithText(ElevatedButton, 'Cadastrar'), findsOneWidget);

    // expect(
    //   find.byType(
    //     TextFormField,
    //   ),
    //   findsNWidgets(3),
    // );
  });
}
