import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:parking_app/core/ui/widgets/parking_loading.dart';
import 'package:parking_app/modules/splash/bloc/splash_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      bloc: context.get<SplashBloc>(),
      listener: (context, state) {
        if (state.status == SplashStatus.success) {
          Navigator.pushReplacementNamed(
            context,
            '/home',
          );
        }

        if (state.status == SplashStatus.failure) {
          Navigator.pushReplacementNamed(
            context,
            '/auth/login',
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: ParkingLoading(),
        ),
      ),
    );
  }
}
