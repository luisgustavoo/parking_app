import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/exceptions/failure.dart';
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
        appBar: AppBar(
          title: const Text('Veículos'),
        ),
        body: BlocBuilder<VehiclesBloc, VehiclesState>(
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
    );
  }

  Widget _buildInitialState() => const SizedBox.shrink();

  Widget _buildLoadingState() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget _buildSuccessState(List<VehiclesModel> vehiclesList) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final vehicle = vehiclesList[index];
        return ListTile(
          title: Text(vehicle.plate),
          subtitle: Text(vehicle.model),
        );
      },
    );
  }

  Widget _buildFailureState(Exception error) {
    String? message;
    if (error is Failure) {
      message = error.message;
    }

    _scaffoldMessengerKey.currentState?.showSnackBar(
      ParkingSnackBar.buildSnackBar(
        content: Text(message ?? 'Erro ao listar veículos'),
        backgroundColor: Colors.red,
        label: '',
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    return const SizedBox.shrink();
  }
}
