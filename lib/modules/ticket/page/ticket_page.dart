import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:parking_app/core/ui/widgets/parking_loading_widget.dart';
import 'package:parking_app/models/ticket_model.dart';
import 'package:parking_app/modules/ticket/bloc/ticket_bloc.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TicketBloc>().add(TicketFindAllEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TicketBloc, TicketState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state.match(
            onInitial: _buildInitialState,
            onLoading: _buildLoadingState,
            onSuccess: _buildSuccessState,
            onFailure: _buildFailureState,
          );
        },
      ),
    );
  }

  Widget _buildInitialState() => const SizedBox.shrink();

  Widget _buildLoadingState() => const Center(
        child: ParkingLoadingWidget(),
      );

  Widget _buildSuccessState({
    List<TicketModel>? ticketList,
    TicketModel? ticket,
  }) {
    if (ticketList?.isEmpty ?? true) {
      return _emptyPage();
    }

    return ListView.builder(
      itemCount: ticketList?.length ?? 0,
      itemBuilder: (context, index) {
        var finalDate = '';

        final ticket = ticketList![index];

        final formatDate = DateFormat(
          'dd/MM/yyyy hh:mm:ss',
        );

        final initialDate = formatDate.format(ticket.entryDataTime);
        if (ticket.departureDateTime != null) {
          finalDate = formatDate.format(ticket.departureDateTime!);
        }

        return ListTile(
          title: Text('Placa ${ticket.vehiclePlate}'),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Text('Data Entrada: $initialDate'),
                  const Icon(
                    Icons.call_received_outlined,
                    color: Colors.green,
                  ),
                ],
              ),
              Visibility(
                visible: ticket.departureDateTime != null,
                child: Row(
                  children: [
                    Text('Data Saída: $finalDate'),
                    const Icon(
                      Icons.call_made_outlined,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
          onTap: () async {
            // await _showVehiclesRegisterPage(vehiclesModel: vehicle);
          },
        );
      },
    );
  }

  Widget _buildFailureState() {
    return const SizedBox.shrink();
  }

  Widget _emptyPage() {
    return const Center(
      child: Text('Nenhum ticket cadastrado'),
    );
  }
}
