import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:parking_app/core/ui/widgets/gap.dart';
import 'package:parking_app/core/ui/widgets/parking_button.dart';
import 'package:parking_app/core/ui/widgets/parking_snack_bar.dart';
import 'package:parking_app/core/ui/widgets/parking_text_form.dart';
import 'package:parking_app/modules/auth/bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _cpfController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late GlobalKey<FormState> _formKey;
  late GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;

  @override
  void initState() {
    super.initState();
    _cpfController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                  label: 'Nome',
                  controller: _nameController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Informe o nome';
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
                ParkingTextForm(
                  label: 'Confirmar Senha',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if ((value?.isEmpty ?? true) ||
                        value != _passwordController.text) {
                      return 'Confirme a senha';
                    }
                    return null;
                  },
                ),
                Gap.vertical(16),
                BlocConsumer<AuthBloc, AuthState>(
                  bloc: context.get(),
                  listener: (context, state) {
                    if (state.status == AuthStatus.failure) {
                      _scaffoldMessengerKey.currentState!.showSnackBar(
                        ParkingSnackBar.buildSnackBar(
                          content: const Text('Erro ao registrar usuário'),
                          backgroundColor: Colors.red,
                          label: '',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }

                    if (state.status == AuthStatus.success) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    }
                  },
                  builder: (context, state) {
                    return ParkingButton(
                      const Text(
                        'Cadastrar',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      isLoading: state.status == AuthStatus.loading,
                      onPressed: () {
                        final valid =
                            _formKey.currentState?.validate() ?? false;

                        if (valid) {
                          context.get<AuthBloc>().add(
                                AuthRegisterEvent(
                                  name: _nameController.text,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
