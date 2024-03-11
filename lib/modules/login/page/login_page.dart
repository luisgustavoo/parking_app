import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/ui/extensions/screen_extension.dart';
import 'package:parking_app/core/ui/extensions/theme_extension.dart';
import 'package:parking_app/core/ui/widgets/gap.dart';
import 'package:parking_app/core/ui/widgets/parking_button.dart';
import 'package:parking_app/core/ui/widgets/parking_snack_bar.dart';
import 'package:parking_app/core/ui/widgets/parking_text_form.dart';
import 'package:parking_app/modules/login/bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _cpfController;
  late final TextEditingController _passwordController;
  late GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    _formKey = GlobalKey<FormState>();

    _cpfController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
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
                  ParkingTextForm(
                    label: 'CPF',
                    controller: _cpfController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Informe o CPF';
                      }
                      return null;
                    },
                  ),
                  Gap.vertical(16),
                  ParkingTextForm(
                    label: 'Senha',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Informe a senha';
                      }
                      return null;
                    },
                  ),
                  Gap.vertical(16),
                  BlocConsumer<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginFailure) {
                        _scaffoldMessengerKey.currentState!.showSnackBar(
                          ParkingSnackBar.buildSnackBar(
                            content: const Text('Erro ao realizar login'),
                            backgroundColor: Colors.red,
                            label: '',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        );
                      }

                      if (state is LoginSuccess) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/parking',
                          (route) => false,
                        );
                      }
                    },
                    builder: (context, state) {
                      return ParkingButton(
                        'Entrar',
                        width: MediaQuery.sizeOf(context).width,
                        isLoading: state is LoginLoading,
                        onPressed: () {
                          final valid =
                              _formKey.currentState?.validate() ?? false;

                          if (valid) {
                            context.read<LoginBloc>().add(
                                  LoginUserEvent(
                                    cpf: _cpfController.text
                                        .replaceAll('.', '')
                                        .replaceAll('-', ''),
                                    password: _passwordController.text,
                                  ),
                                );
                          }
                        },
                      );
                    },
                  ),
                  Gap.vertical(16),
                  ParkingButton(
                    'Cadastrar',
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
        ),
      ),
    );
  }
}
