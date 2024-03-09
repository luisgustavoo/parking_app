import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking_app/core/ui/widgets/gap.dart';
import 'package:parking_app/core/ui/widgets/parking_button.dart';
import 'package:parking_app/core/ui/widgets/parking_text_form.dart';

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
  late GlobalKey _formKey;

  @override
  void initState() {
    super.initState();
    _cpfController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  if (value?.isEmpty ?? true) {
                    return 'Confirme a senha';
                  }
                  return null;
                },
              ),
              Gap.vertical(16),
              ParkingButton(
                const Text(
                  'Cadastrar',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                width: MediaQuery.sizeOf(context).width,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
