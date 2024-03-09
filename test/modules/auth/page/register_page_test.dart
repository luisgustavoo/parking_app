import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app/modules/auth/page/register_page.dart';

import '../../../core/mocks/bindings/mock_application_binding.dart';
import '../mocks/mock_auth_bloc.dart';
import '../mocks/mock_auth_module.dart';

void main() {
  Widget createRegisterPage() {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: FlutterGetIt(
        bindings: MockApplicationBinding(),
        modules: [
          MockAuthModule(),
        ],
        builder: (context, routes, flutterGetItNavObserver) {
          return MaterialApp(
            title: 'Parking',
            navigatorObservers: [flutterGetItNavObserver],
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
            // initialRoute: '/auth/register',
            // routes: routes,
            home: const RegisterPage(),
          );
        },
      ),
    );
  }

  testWidgets('Test if register page shows up', (tester) async {
    await tester.pumpWidget(createRegisterPage());

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
