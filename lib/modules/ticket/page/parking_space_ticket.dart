import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/ui/extensions/theme_extension.dart';
import 'package:parking_app/core/ui/widgets/parking_button.dart';
import 'package:parking_app/core/ui/widgets/parking_loading.dart';
import 'package:parking_app/models/parking_space_model.dart';
import 'package:parking_app/models/ticket_model.dart';
import 'package:parking_app/models/vehicles_model.dart';
import 'package:parking_app/modules/ticket/bloc/register/ticket_register_bloc.dart';
import 'package:parking_app/modules/vehicles/bloc/vehicles_bloc.dart';

class ParkingSpaceTicket extends StatefulWidget {
  const ParkingSpaceTicket({
    required this.parkingSpaceModel,
    super.key,
  });

  final ParkingSpaceModel parkingSpaceModel;

  @override
  State<ParkingSpaceTicket> createState() => _ParkingSpaceTicketState();
}

class _ParkingSpaceTicketState extends State<ParkingSpaceTicket> {
  VehiclesModel? _selectedVehicle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<VehiclesBloc, VehiclesState>(
            builder: (context, state) {
              return state.match(
                onInitial: _buildInitialState,
                onLoading: _buildLoadingState,
                onSuccess: _buildSuccessState,
                onFailure: _buildFailureState,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: BlocConsumer<TicketRegisterBloc, TicketRegisterState>(
              listener: (context, state) {
                if (state is TicketRegisterFailure) {
                  Navigator.pop(
                    context,
                    (
                      state: state,
                      vehicle: null,
                    ),
                  );
                }
                if (state is TicketRegisterSuccess) {
                  Navigator.pop(
                    context,
                    (
                      state: state,
                      vehicle: _selectedVehicle,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return ParkingButton(
                  'Registrar Entrada',
                  isLoading: state is TicketRegisterLoading,
                  onPressed: _ticketRegister,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() => const SizedBox.shrink();

  Widget _buildLoadingState() => const Center(
        child: ParkingLoading(),
      );

  Widget _buildSuccessState(List<VehiclesModel> vehiclesList) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        itemCount: vehiclesList.length,
        itemBuilder: (context, index) {
          final vehicle = vehiclesList[index];
          return RadioListTile<VehiclesModel>(
            title: Text('Placa ${vehicle.plate}'),
            subtitle: Text('Modelo ${vehicle.model}'),
            selectedTileColor: context.colorScheme.inversePrimary,
            selected: vehicle == _selectedVehicle,
            value: vehicle,
            groupValue: _selectedVehicle,
            onChanged: (vehicle) {
              setState(() {
                _selectedVehicle = vehicle;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildFailureState() => const SizedBox.shrink();

  void _ticketRegister() {
    if (_selectedVehicle != null) {
      final ticketModel = TicketModel(
        entryDataTime: DateTime.now(),
        parkingSpaceId: widget.parkingSpaceModel.id!,
        vehiclePlate: _selectedVehicle!.plate,
      );
      context.read<TicketRegisterBloc>().add(
            TicketRegisterTicketEvent(
              ticketModel: ticketModel,
            ),
          );
    }
  }
}
