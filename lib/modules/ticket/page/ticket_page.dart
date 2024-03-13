import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/helpers/utils.dart';
import 'package:parking_app/core/ui/widgets/gap.dart';
import 'package:parking_app/core/ui/widgets/parking_button.dart';
import 'package:parking_app/core/ui/widgets/parking_loading_widget.dart';
import 'package:parking_app/core/ui/widgets/parking_snack_bar.dart';
import 'package:parking_app/models/payment_model.dart';
import 'package:parking_app/models/ticket_model.dart';
import 'package:parking_app/modules/daily_closing/bloc/daily_closing_bloc.dart';
import 'package:parking_app/modules/ticket/bloc/ticket_bloc.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    context.read<TicketBloc>().add(
          TicketFindByDateEvent(
            date: DateTime.now(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: BlocConsumer<TicketBloc, TicketState>(
          listener: (context, state) {},
          builder: (context, state) {
            return state.match(
              onInitial: _buildInitialState,
              onLoading: _buildLoadingState,
              onSuccess: () {
                return _buildSuccessState(
                  ticketList: state.ticketList,
                );
              },
              onFailure: _buildFailureState,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog<DailyClosingStatus>(
              context: context,
              builder: _buildDialog,
            );

            if (result != null) {
              if (result == DailyClosingStatus.failure) {
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  ParkingSnackBar.buildSnackBar(
                    content: const Text('Erro registrar fechamento diário'),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              if (result == DailyClosingStatus.success) {
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  ParkingSnackBar.buildSnackBar(
                    content: const Text('Fechamento realizado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            }
          },
          child: const Icon(Icons.attach_money_outlined),
        ),
      ),
    );
  }

  AlertDialog _buildDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Deseja fazer o fechamento do dia?'),
      actions: [
        BlocConsumer<DailyClosingBloc, DailyClosingState>(
          listener: (context, state) {
            if (state.status == DailyClosingStatus.success) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context, state.status);
              }
            }

            if (state.status == DailyClosingStatus.failure) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context, state.status);
              }
            }
          },
          builder: (context, state) {
            return ParkingButton(
              'Sim',
              height: 30,
              width: 50,
              style: ParkingButtonStyle.secondary,
              isLoading: state.status == DailyClosingStatus.loading,
              onPressed: () {
                final ticketList = context.read<TicketBloc>().ticketList;
                final filteredDate = context.read<TicketBloc>().filteredDate;
                if ((ticketList?.isNotEmpty ?? false) && filteredDate != null) {
                  context.read<DailyClosingBloc>().add(
                        DailyClosingRegisterEvent(
                          ticketList: ticketList!,
                          filteredDate: filteredDate,
                        ),
                      );
                } else {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }
              },
            );
          },
        ),
        ParkingButton(
          'Não',
          height: 30,
          width: 50,
          style: ParkingButtonStyle.secondary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildInitialState() => const SizedBox.shrink();

  Widget _buildLoadingState() => const Center(
        child: ParkingLoadingWidget(),
      );

  Widget _buildSuccessState({
    List<TicketModel>? ticketList,
  }) {
    if (ticketList?.isEmpty ?? true) {
      return _emptyPage();
    }

    return ListView.builder(
      itemCount: ticketList?.length ?? 0,
      itemBuilder: (context, index) {
        var finalDate = '';

        final ticket = ticketList![index];

        if (ticket.departureDateTime != null) {
          finalDate = Utils.dateFormat(date: ticket.departureDateTime!);
        }

        return ListTile(
          title: Text('Placa ${ticket.vehiclePlate}'),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.call_received_outlined,
                            color: Colors.green,
                            size: 20,
                          ),
                          Text(
                            Utils.dateFormat(date: ticket.entryDataTime),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: ticket.departureDateTime != null,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.call_made_outlined,
                              color: Colors.red,
                              size: 20,
                            ),
                            Text(
                              finalDate,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap.horizontal(8),
                  Text(
                    '${Utils.differenceInTime(
                      initialDate: ticket.entryDataTime,
                    )} hs',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Column(
            children: [
              Text(
                Utils.currencyFormat(
                  value: ticket.amountPaid ?? 0,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                ticket.paymentType?.toStringTypeTranslate() ?? '',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
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
