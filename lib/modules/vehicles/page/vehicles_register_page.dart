import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/ui/widgets/gap.dart';
import 'package:parking_app/core/ui/widgets/parking_button.dart';
import 'package:parking_app/core/ui/widgets/parking_snack_bar.dart';
import 'package:parking_app/core/ui/widgets/parking_text_form.dart';
import 'package:parking_app/models/vehicles_model.dart';
import 'package:parking_app/modules/vehicles/bloc/register/vehicles_register_bloc.dart';

class VehiclesRegisterPage extends StatefulWidget {
  const VehiclesRegisterPage({this.vehiclesModel, super.key});

  final VehiclesModel? vehiclesModel;

  @override
  State<VehiclesRegisterPage> createState() => _VehiclesRegisterPageState();
}

class _VehiclesRegisterPageState extends State<VehiclesRegisterPage> {
  late VehiclesType _type;
  late TextEditingController _plateController;
  late TextEditingController _modelController;
  late TextEditingController _colorController;
  late TextEditingController _ownerController;
  late GlobalKey<FormState> _formKey;
  late GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.vehiclesModel?.plate);
    _modelController = TextEditingController(text: widget.vehiclesModel?.model);
    _colorController = TextEditingController(text: widget.vehiclesModel?.color);
    _ownerController = TextEditingController(text: widget.vehiclesModel?.owner);
    _type = widget.vehiclesModel?.type ?? VehiclesType.car;

    _formKey = GlobalKey<FormState>();
    _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  }

  @override
  void dispose() {
    super.dispose();
    _plateController.dispose();
    _modelController.dispose();
    _colorController.dispose();
    _ownerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastrar Veículo'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete_outline_outlined,
                color: Colors.red,
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ParkingTextForm(
                  label: 'Placa',
                  controller: _plateController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Informe a placa';
                    }
                    return null;
                  },
                ),
                Gap.vertical(16),
                ParkingTextForm(
                  label: 'Modelo',
                  controller: _modelController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Informe o modelo';
                    }
                    return null;
                  },
                ),
                Gap.vertical(16),
                ParkingTextForm(
                  label: 'Cor',
                  controller: _colorController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Informe a cor';
                    }
                    return null;
                  },
                ),
                Gap.vertical(16),
                ParkingTextForm(
                  label: 'Proprietário',
                  controller: _ownerController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Informe o proprietário';
                    }
                    return null;
                  },
                ),
                Gap.vertical(16),
                Row(
                  children: [
                    Radio(
                      value: VehiclesType.car,
                      groupValue: _type,
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                    ),
                    const Text('Carro'),
                    Gap.horizontal(16),
                    Radio(
                      value: VehiclesType.motorcycle,
                      groupValue: _type,
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                    ),
                    const Text('Moto'),
                  ],
                ),
                Gap.vertical(16),
                BlocConsumer<VehiclesRegisterBloc, VehiclesRegisterState>(
                  listener: (context, state) async {
                    if (state is VehiclesRegisterFailure) {
                      _scaffoldMessengerKey.currentState!.showSnackBar(
                        ParkingSnackBar.buildSnackBar(
                          content: const Text('Erro ao registrar veículo'),
                          backgroundColor: Colors.red,
                          label: '',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }

                    if (state is VehiclesRegisterSuccess) {
                      _scaffoldMessengerKey.currentState!.showSnackBar(
                        ParkingSnackBar.buildSnackBar(
                          content:
                              const Text('Cadastro realizado com sucesso!!'),
                          backgroundColor: Colors.green,
                          label: '',
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      );

                      await Future<void>.delayed(const Duration(seconds: 2))
                          .whenComplete(
                        () => Navigator.pop(context),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ParkingButton(
                      const Text(
                        'Cadastrar',
                        style: TextStyle(color: Colors.white),
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      isLoading: state is VehiclesRegisterLoading,
                      onPressed: () {
                        final valid =
                            _formKey.currentState?.validate() ?? false;

                        if (valid) {
                          context.read<VehiclesRegisterBloc>().add(
                                VehiclesRegisterVehicleEvent(
                                  plate: _plateController.text,
                                  model: _modelController.text,
                                  color: _colorController.text,
                                  type: _type,
                                  owner: _ownerController.text,
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
