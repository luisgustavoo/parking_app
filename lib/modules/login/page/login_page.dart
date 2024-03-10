import 'package:flutter/material.dart';
import 'package:parking_app/core/ui/extensions/screen_extension.dart';
import 'package:parking_app/core/ui/extensions/theme_extension.dart';
import 'package:parking_app/core/ui/widgets/gap.dart';
import 'package:parking_app/core/ui/widgets/parking_button.dart';
import 'package:parking_app/core/ui/widgets/parking_text_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_car,
                size: 150.dm,
                color: context.primaryColor,
              ),
              Text(
                'Parking',
                style: TextStyle(
                  fontSize: 24.sp,
                  color: context.primaryColor,
                ),
              ),
              Gap.vertical(16),
              ParkingTextForm(label: 'CPF'),
              Gap.vertical(16),
              ParkingTextForm(
                label: 'Senha',
                obscureText: true,
              ),
              Gap.vertical(16),
              ParkingButton(
                const Text(
                  'Entrar',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                width: MediaQuery.sizeOf(context).width,
                onPressed: () {},
              ),
              Gap.vertical(16),
              ParkingButton(
                Text(
                  'Cadastrar',
                  style: TextStyle(
                    color: context.primaryColor,
                  ),
                ),
                style: ParkingButtonStyle.secondary,
                width: MediaQuery.sizeOf(context).width,
                onPressed: () {
                  Navigator.pushNamed(context, '/auth/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
