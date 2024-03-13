import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/helpers/utils.dart';
import 'package:parking_app/core/ui/widgets/parking_loading_widget.dart';
import 'package:parking_app/core/ui/widgets/parking_snack_bar.dart';
import 'package:parking_app/models/daily_closing_model.dart';
import 'package:parking_app/modules/daily_closing/bloc/daily_closing_bloc.dart';

class DailyClosingPage extends StatefulWidget {
  const DailyClosingPage({super.key});

  @override
  State<DailyClosingPage> createState() => _DailyClosingPageState();
}

class _DailyClosingPageState extends State<DailyClosingPage> {
  @override
  void initState() {
    super.initState();

    context.read<DailyClosingBloc>().add(
          DailyClosingFindAllEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: BlocConsumer<DailyClosingBloc, DailyClosingState>(
          listener: (context, state) {
            if (state.status == DailyClosingStatus.failure) {
              scaffoldMessengerKey.currentState?.showSnackBar(
                ParkingSnackBar.buildSnackBar(
                  content: const Text('Erro ao listar dados do fechamento'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return state.match(
              onInitial: _buildInitialState,
              onLoading: _buildLoadingState,
              onSuccess: () {
                return _buildSuccessState(state.dailyClosingList);
              },
              onFailure: _buildFailureState,
            );
          },
        ),
      ),
    );
  }

  Widget _buildInitialState() => const SizedBox.shrink();

  Widget _buildLoadingState() => const Center(
        child: ParkingLoadingWidget(),
      );

  Widget _buildSuccessState(List<DailyClosingModel>? dailyClosingList) {
    if (dailyClosingList?.isEmpty ?? true) {
      return _emptyPage();
    }

    return ListView.builder(
      itemCount: dailyClosingList!.length,
      itemBuilder: (context, index) {
        final dailyClosing = dailyClosingList[index];

        final dailyClosingDate = Utils.dateFormat(
          date: dailyClosing.date,
          showTime: false,
        );

        return ListTile(
          title: Text('Dia $dailyClosingDate'),
          trailing: Text(
            Utils.currencyFormat(
              value: dailyClosing.amount,
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
      child: Text('Nenhum registro cadastrado'),
    );
  }
}
