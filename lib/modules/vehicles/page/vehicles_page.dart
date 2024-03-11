import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/rest_client/dio_rest_client.dart';
import 'package:parking_app/core/rest_client/logs/log_impl.dart';
import 'package:parking_app/core/ui/widgets/parking_snack_bar.dart';
import 'package:parking_app/models/vehicles_model.dart';
import 'package:parking_app/modules/vehicles/bloc/vehicles_bloc.dart';
import 'package:parking_app/modules/vehicles/repository/vehicles_repository.dart';
import 'package:provider/provider.dart';

class VehiclesProvider extends StatelessWidget {
  const VehiclesProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
      ],
      child: const VehiclesPage(),
    );
  }
}

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: BlocListener<VehiclesBloc, VehiclesState>(
          listener: (context, state) {
            if (state is VehiclesFailure) {
              if (mounted) {
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  ParkingSnackBar.buildSnackBar(
                    content: const Text('Erro ao listar veículos'),
                    backgroundColor: Colors.red,
                    label: '',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              }
            }
          },
          child: BlocBuilder<VehiclesBloc, VehiclesState>(
            builder: (context, state) {
              return state.match(
                onInitial: _buildInitialState,
                onLoading: _buildLoadingState,
                onSuccess: _buildSuccessState,
                onFailure: _buildFailureState,
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final bloc = BlocProvider.of<VehiclesBloc>(context);
            final result =
                await Navigator.pushNamed(context, '/vehicles/register')
                    as bool?;

            if (result ?? false) {
              bloc.add(VehiclesFindAllEvent());
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildInitialState() => const SizedBox.shrink();

  Widget _buildLoadingState() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget _buildSuccessState(List<VehiclesModel> vehiclesList) {
    return ListView.builder(
      itemCount: vehiclesList.length,
      itemBuilder: (context, index) {
        final vehicle = vehiclesList[index];
        return ListTile(
          title: Text(vehicle.plate),
          subtitle: Text(vehicle.model),
        );
      },
    );
  }

  Widget _buildFailureState() {
    return const SizedBox.shrink();
  }
}
