import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/ui/widgets/parking_loading_widget.dart';
import 'package:parking_app/core/ui/widgets/parking_snack_bar.dart';
import 'package:parking_app/models/vehicles_model.dart';
import 'package:parking_app/modules/vehicles/bloc/vehicles_bloc.dart';

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
              _scaffoldMessengerKey.currentState?.showSnackBar(
                ParkingSnackBar.buildSnackBar(
                  content: const Text('Erro ao listar veículos'),
                  backgroundColor: Colors.red,
                ),
              );
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
            await _showVehiclesRegisterPage();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildInitialState() => const SizedBox.shrink();

  Widget _buildLoadingState() => const Center(
        child: ParkingLoadingWidget(),
      );

  Widget _buildSuccessState(List<VehiclesModel> vehiclesList) {
    if (vehiclesList.isEmpty) {
      return _emptyPage();
    }

    return ListView.builder(
      itemCount: vehiclesList.length,
      itemBuilder: (context, index) {
        final vehicle = vehiclesList[index];
        return ListTile(
          title: Text('Placa ${vehicle.plate}'),
          subtitle: Text('Modelo ${vehicle.model}'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Proprietário',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(vehicle.owner),
            ],
          ),
          onTap: () async {
            await _showVehiclesRegisterPage(vehiclesModel: vehicle);
          },
        );
      },
    );
  }

  Widget _buildFailureState() {
    return const SizedBox.shrink();
  }

  Future<void> _showVehiclesRegisterPage({VehiclesModel? vehiclesModel}) async {
    final bloc = BlocProvider.of<VehiclesBloc>(context);
    final result = await Navigator.pushNamed(
      context,
      '/vehicles/register',
      arguments: vehiclesModel,
    ) as bool?;

    if (result ?? false) {
      bloc.add(VehiclesFindAllEvent());
    }
  }

  Widget _emptyPage() {
    return const Center(
      child: Text('Nenhum veículo cadastrado'),
    );
  }
}
