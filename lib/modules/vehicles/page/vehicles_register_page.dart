import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/rest_client/dio_rest_client.dart';
import 'package:parking_app/core/rest_client/logs/log_impl.dart';
import 'package:parking_app/core/ui/widgets/gap.dart';
import 'package:parking_app/core/ui/widgets/parking_button.dart';
import 'package:parking_app/core/ui/widgets/parking_loading_widget.dart';
import 'package:parking_app/core/ui/widgets/parking_snack_bar.dart';
import 'package:parking_app/core/ui/widgets/parking_text_form.dart';
import 'package:parking_app/models/vehicles_model.dart';
import 'package:parking_app/modules/vehicles/bloc/register/vehicles_register_bloc.dart';
import 'package:parking_app/modules/vehicles/repository/vehicles_register_repository.dart';
import 'package:provider/provider.dart';

class VehiclesRegisterProvider extends StatelessWidget {
  const VehiclesRegisterProvider({this.vehiclesModel, super.key});
  final VehiclesModel? vehiclesModel;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => VehiclesRegisterRepository(
            restClient: context.read<DioRestClient>(),
            log: context.read<LogImpl>(),
          ),
        ),
        BlocProvider(
          create: (context) => VehiclesRegisterBloc(
            vehiclesRegisterRepository:
                context.read<VehiclesRegisterRepository>(),
            log: context.read<LogImpl>(),
          ),
        ),
      ],
      child: VehiclesRegisterPage(
        vehiclesModel: vehiclesModel,
      ),
    );
  }
}

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
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.vehiclesModel?.plate);
    _modelController = TextEditingController(text: widget.vehiclesModel?.model);
    _colorController = TextEditingController(text: widget.vehiclesModel?.color);
    _ownerController = TextEditingController(text: widget.vehiclesModel?.owner);
    _type = widget.vehiclesModel?.type ?? VehiclesType.car;

    isUpdate = widget.vehiclesModel != null;

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
            Visibility(
              visible: isUpdate,
              child: BlocConsumer<VehiclesRegisterBloc, VehiclesRegisterState>(
                listener: (context, state) {
                  if (state.status == VehiclesRegisterStatus.loading) {
                    _scaffoldMessengerKey.currentState!.showSnackBar(
                      ParkingSnackBar.buildSnackBar(
                        content: const Text('Erro ao excluir veículo'),
                        backgroundColor: Colors.red,
                        label: 'Fechar',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }

                  if (state.status == VehiclesRegisterStatus.success) {
                    Navigator.pop(context, true);
                  }
                },
                listenWhen: (previous, current) {
                  return (previous.status == VehiclesRegisterStatus.deleting) &&
                      ((current.status ==
                              VehiclesRegisterStatus.deletingSuccess) ||
                          (current.status ==
                              VehiclesRegisterStatus.deletingFailure));
                },
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      if (isUpdate) {
                        context.read<VehiclesRegisterBloc>().add(
                              VehiclesDeleteEvent(
                                id: widget.vehiclesModel!.id!,
                              ),
                            );
                      }
                    },
                    icon: state.status == VehiclesRegisterStatus.deleting
                        ? const SizedBox(
                            width: 10,
                            height: 10,
                            child: ParkingLoadingWidget(),
                          )
                        : const Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                          ),
                  );
                },
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
                    if (state.status == VehiclesRegisterStatus.failure) {
                      _scaffoldMessengerKey.currentState!.showSnackBar(
                        ParkingSnackBar.buildSnackBar(
                          content: const Text('Erro ao registrar veículo'),
                          backgroundColor: Colors.red,
                          label: 'Fechar',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    }

                    if (state.status == VehiclesRegisterStatus.success) {
                      _scaffoldMessengerKey.currentState!.showSnackBar(
                        ParkingSnackBar.buildSnackBar(
                          content: Text(
                            isUpdate
                                ? 'Dados atualizados com sucesso!!'
                                : 'Cadastro realizado com sucesso!!',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      await Future<void>.delayed(const Duration(seconds: 1))
                          .whenComplete(
                        () => Navigator.pop(context, true),
                      );
                    }
                  },
                  builder: (context, state) {
                    return ParkingButton(
                      isUpdate ? 'Atualizar' : 'Cadastrar',
                      width: MediaQuery.sizeOf(context).width,
                      isLoading: state.status == VehiclesRegisterStatus.loading,
                      onPressed: () {
                        final valid =
                            _formKey.currentState?.validate() ?? false;

                        if (valid) {
                          if (isUpdate) {
                            context.read<VehiclesRegisterBloc>().add(
                                  VehiclesUpdateEvent(
                                    vehiclesModel:
                                        widget.vehiclesModel!.copyWith(
                                      id: widget.vehiclesModel!.id,
                                      plate: _plateController.text,
                                      model: _modelController.text,
                                      color: _colorController.text,
                                      type: _type,
                                      owner: _ownerController.text,
                                    ),
                                  ),
                                );
                          } else {
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
