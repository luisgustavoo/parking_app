import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:parking_app/core/helpers/calculate.dart';
import 'package:parking_app/core/ui/extensions/theme_extension.dart';
import 'package:parking_app/core/ui/widgets/gap.dart';
import 'package:parking_app/core/ui/widgets/parking_button.dart';
import 'package:parking_app/core/ui/widgets/parking_loading_widget.dart';
import 'package:parking_app/models/parking_space_model.dart';
import 'package:parking_app/models/payment_model.dart';
import 'package:parking_app/models/ticket_model.dart';
import 'package:parking_app/models/vehicles_model.dart';
import 'package:parking_app/modules/parking/bloc/parking_bloc.dart';

import 'package:parking_app/modules/ticket/bloc/register/ticket_register_bloc.dart';
import 'package:parking_app/modules/ticket/bloc/ticket_bloc.dart';
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

  bool _disableButton = false;

  PaymentType _type = PaymentType.money;

  @override
  void initState() {
    super.initState();
    if (widget.parkingSpaceModel.occupied) {
      context.read<TicketBloc>().add(
            TicketFindByParkingSpaceIdEvent(
              id: widget.parkingSpaceModel.id!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: switch (widget.parkingSpaceModel.occupied) {
        true => _buildFinalizeTicket(),
        _ => _buildRegisterTicket()
      },
    );
  }

  Widget _buildFinalizeTicket() {
    return BlocBuilder<TicketBloc, TicketState>(
      builder: (context, state) {
        return state.match(
          onInitial: _buildInitialState,
          onLoading: _buildLoadingState,
          onSuccess: _buildSuccessTicket,
          onFailure: _buildFailureState,
        );
      },
    );
  }

  Widget _buildRegisterTicket() {
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
                  disable: _disableButton,
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
        child: ParkingLoadingWidget(),
      );

  Widget _buildSuccessState(List<VehiclesModel> vehiclesList) {
    final filteredList = vehiclesList
        .where(
          (vehicle) => vehicle.type == widget.parkingSpaceModel.type,
        )
        .toList();

    if (filteredList.isEmpty) {
      _disableButton = true;

      return _emptyPage(widget.parkingSpaceModel);
    }

    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.7),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          final vehicle = filteredList[index];
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

  Widget _buildSuccessTicket({
    List<TicketModel>? ticketList,
    TicketModel? ticket,
  }) {
    if (ticket == null) {}

    final valuePerHour =
        context.read<ParkingBloc>().parkingModel?.hourlyRate ?? 0;

    final formatDate = DateFormat(
      'dd/MM/yyyy hh:mm:ss',
    );

    final initialDate = formatDate.format(ticket!.entryDataTime);

    final time = Calculate.differenceInTime(
      initialDate: ticket.entryDataTime.toLocal(),
    );

    final amountPaid = Calculate.amountPaid(
      valuePerHour: valuePerHour,
      minutes:
          DateTime.now().difference(ticket.entryDataTime.toLocal()).inMinutes,
    );

    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icon/icon_car_left.svg',
                ),
                Gap.horizontal(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.parkingSpaceModel.vehicle?.model ?? ''}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      'Placa: ${widget.parkingSpaceModel.vehicle?.plate ?? ''}',
                      // style: const TextStyle(
                      //   fontWeight: FontWeight.bold,
                      // ),
                    ),
                    Text(
                      'Proprietário: ${widget.parkingSpaceModel.vehicle?.owner ?? ''}',
                      // style: const TextStyle(
                      //   fontWeight: FontWeight.bold,
                      // ),
                    ),
                  ],
                ),
              ],
            ),
            Gap.vertical(16),
            Text('Data Entrada: $initialDate '),
            Text(
              'Tempo: $time hs ',
            ),
            Gap.vertical(8),
            Text(
              'Valor: R\$${NumberFormat.currency(
                locale: 'pt-BR',
                name: '',
                decimalDigits: 2,
              ).format(amountPaid)} ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Row(
              children: [
                Radio(
                  value: PaymentType.money,
                  groupValue: _type,
                  onChanged: (value) {
                    setState(() {
                      _type = value!;
                    });
                  },
                ),
                const Text('Dinheiro'),
                Gap.horizontal(16),
                Radio(
                  value: PaymentType.card,
                  groupValue: _type,
                  onChanged: (value) {
                    setState(() {
                      _type = value!;
                    });
                  },
                ),
                const Text('Cartão de Credito'),
              ],
            ),
            Gap.vertical(16),
            ParkingButton(
              'Registar Saída',
            ),
          ],
        ),
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

  Widget _emptyPage(ParkingSpaceModel parkingSpaceModel) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 200,
      ),
      child: Center(
        child: parkingSpaceModel.type == VehiclesType.car
            ? const Text('Nenhum carro cadastrado')
            : const Text('Nenhuma moto cadastrada'),
      ),
    );
  }
}
