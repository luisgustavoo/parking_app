import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:parking_app/core/application_start_config.dart';
import 'package:parking_app/core/rest_client/dio_rest_client.dart';
import 'package:parking_app/core/rest_client/local_storages/flutter_secure_storage_local_storage_impl.dart';
import 'package:parking_app/core/rest_client/local_storages/navigator/parking_navigator.dart';
import 'package:parking_app/core/rest_client/local_storages/shared_preferences_local_storage_impl.dart';
import 'package:parking_app/core/rest_client/logs/log_impl.dart';
import 'package:parking_app/models/vehicles_model.dart';
import 'package:parking_app/modules/login/bloc/login_bloc.dart';
import 'package:parking_app/modules/login/page/login_page.dart';
import 'package:parking_app/modules/login/repository/login_repository.dart';
import 'package:parking_app/modules/login/service/login_service.dart';
import 'package:parking_app/modules/parking/bloc/parking_bloc.dart';
import 'package:parking_app/modules/parking/page/parking_page.dart';
import 'package:parking_app/modules/parking/repository/parking_repository.dart';
import 'package:parking_app/modules/register/bloc/register_bloc.dart';
import 'package:parking_app/modules/register/page/register_page.dart';
import 'package:parking_app/modules/register/repository/register_repository.dart';
import 'package:parking_app/modules/register/service/register_service.dart';
import 'package:parking_app/modules/splash/bloc/splash_bloc.dart';
import 'package:parking_app/modules/splash/page/splash_page.dart';
import 'package:parking_app/modules/ticket/bloc/register/ticket_register_bloc.dart';
import 'package:parking_app/modules/ticket/bloc/ticket_bloc.dart';
import 'package:parking_app/modules/ticket/repository/ticket_repository.dart';
import 'package:parking_app/modules/vehicles/bloc/vehicles_bloc.dart';
import 'package:parking_app/modules/vehicles/page/vehicles_register_page.dart';
import 'package:parking_app/modules/vehicles/repository/vehicles_repository.dart';
import 'package:provider/provider.dart';

void main() async {
  await ApplicationStartConfig().configureApp();

  Intl.defaultLocale = 'pt_BR';

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) {
        return MultiProvider(
          providers: [
            Provider(
              lazy: false,
              create: (_) => SharedPreferencesLocalStorageImpl(),
            ),
            Provider(
              lazy: false,
              create: (_) => FlutterSecureStorageLocalStorageImpl(),
            ),
            Provider(
              lazy: false,
              create: (_) => LogImpl(),
            ),
            Provider(
              lazy: false,
              create: (context) => DioRestClient(
                localSecurityStorage:
                    context.read<FlutterSecureStorageLocalStorageImpl>(),
                localStorage: context.read<SharedPreferencesLocalStorageImpl>(),
                log: context.read<LogImpl>(),
              ),
            ),
            Provider(
              create: (context) => ParkingRepository(
                restClient: context.read<DioRestClient>(),
                log: context.read<LogImpl>(),
              ),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => ParkingBloc(
                parkingRepository: context.read<ParkingRepository>(),
                log: context.read<LogImpl>(),
              )..add(ParkingFindAllEvent()),
            ),
            Provider(
              create: (context) => VehiclesRepository(
                restClient: context.read<DioRestClient>(),
                log: context.read<LogImpl>(),
              ),
            ),
            BlocProvider(
              create: (context) => VehiclesBloc(
                vehiclesRepository: context.read<VehiclesRepository>(),
                log: context.read<LogImpl>(),
              )..add(VehiclesFindAllEvent()),
            ),
            Provider(
              create: (context) => TicketRepository(
                restClient: context.read<DioRestClient>(),
                log: context.read<LogImpl>(),
              ),
            ),
            BlocProvider(
              create: (context) => TicketRegisterBloc(
                ticketRepository: context.read<TicketRepository>(),
                log: context.read<LogImpl>(),
              ),
            ),
            BlocProvider(
              create: (context) => TicketBloc(
                ticketRepository: context.read<TicketRepository>(),
                log: context.read<LogImpl>(),
              ),
            ),
          ],
          builder: (context, child) {
            return MaterialApp(
              title: 'Parking',
              navigatorKey: ParkingNavigator.navigatorKey,
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
              initialRoute: '/',
              routes: {
                '/': (context) {
                  return BlocProvider(
                    create: (context) => SplashBloc(
                      localStorage:
                          context.read<SharedPreferencesLocalStorageImpl>(),
                    )..add(SplashVerifyLocalUserEvent()),
                    child: const SplashPage(),
                  );
                },
                '/auth/register': (context) {
                  return MultiProvider(
                    providers: [
                      Provider(
                        create: (context) => RegisterRepository(
                          restClient: context.read<DioRestClient>(),
                          log: context.read<LogImpl>(),
                        ),
                      ),
                      Provider(
                        create: (context) => RegisterService(
                          registerRepository:
                              context.read<RegisterRepository>(),
                          localStorage:
                              context.read<SharedPreferencesLocalStorageImpl>(),
                          log: context.read<LogImpl>(),
                        ),
                      ),
                      BlocProvider(
                        create: (context) => RegisterBloc(
                          registerService: context.read<RegisterService>(),
                          log: context.read<LogImpl>(),
                        ),
                      ),
                    ],
                    child: const RegisterPage(),
                  );
                },
                '/auth/login': (context) {
                  return MultiProvider(
                    providers: [
                      Provider(
                        create: (context) => LoginRepository(
                          restClient: context.read<DioRestClient>(),
                          log: context.read<LogImpl>(),
                        ),
                      ),
                      Provider(
                        create: (context) => LoginService(
                          loginRepository: context.read<LoginRepository>(),
                          localSecurityStorage: context
                              .read<FlutterSecureStorageLocalStorageImpl>(),
                          localStorage:
                              context.read<SharedPreferencesLocalStorageImpl>(),
                          log: context.read<LogImpl>(),
                        ),
                      ),
                      BlocProvider(
                        create: (context) => LoginBloc(
                          loginService: context.read<LoginService>(),
                          log: context.read<LogImpl>(),
                        ),
                      ),
                    ],
                    child: const LoginPage(),
                  );
                },
                '/parking': (context) => const ParkingPage(),
                '/vehicles/register': (context) {
                  final args = ModalRoute.of(context)?.settings.arguments;
                  if (args != null) {
                    return VehiclesRegisterProvider(
                      vehiclesModel: args as VehiclesModel,
                    );
                  }
                  return const VehiclesRegisterProvider();
                },
              },
            );
          },
        );
      },
    );
  }
}
