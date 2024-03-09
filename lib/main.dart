import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parking_app/core/application_start_config.dart';
import 'package:parking_app/modules/auth/auth_module.dart';
import 'package:parking_app/modules/splash/splash_module.dart';

void main() async {
  await ApplicationStartConfig().configureApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      child: FlutterGetIt(
        modules: [
          SplashModule(),
          AuthModule(),
        ],
        builder: (context, routes, flutterGetItNavObserver) {
          return MaterialApp(
            title: 'Parking',
            // navigatorKey: ParkingNavigator.navigatorKey,
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
            routes: routes,
          );
        },
      ),
    );
  }
}
