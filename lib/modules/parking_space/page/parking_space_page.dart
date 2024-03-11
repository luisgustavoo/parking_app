import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/rest_client/dio_rest_client.dart';
import 'package:parking_app/core/rest_client/logs/log_impl.dart';
import 'package:parking_app/core/ui/widgets/parking_snack_bar.dart';
import 'package:parking_app/core/ui/widgets/parking_space_card.dart';
import 'package:parking_app/models/parking_space_model.dart';
import 'package:parking_app/modules/parking_space/bloc/parking_space_bloc.dart';
import 'package:parking_app/modules/parking_space/repository/parking_space_repository.dart';
import 'package:parking_app/modules/ticket/page/parking_space_ticket.dart';
import 'package:provider/provider.dart';

class ParkingSpaceProvider extends StatelessWidget {
  const ParkingSpaceProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => ParkingSpaceRepository(
            restClient: context.read<DioRestClient>(),
            log: context.read<LogImpl>(),
          ),
        ),
        BlocProvider(
          create: (context) => ParkingSpaceBloc(
            parkingSpaceRepository: context.read<ParkingSpaceRepository>(),
            log: context.read<LogImpl>(),
          )..add(ParkingSpaceFindAllEvent()),
        ),
      ],
      child: const ParkingSpacePage(),
    );
  }
}

class ParkingSpacePage extends StatefulWidget {
  const ParkingSpacePage({super.key});

  @override
  State<ParkingSpacePage> createState() => _ParkingSpacePageState();
}

class _ParkingSpacePageState extends State<ParkingSpacePage> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: BlocConsumer<ParkingSpaceBloc, ParkingSpaceState>(
          listener: (context, state) {
            if (state is ParkingSpaceFailure) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                ParkingSnackBar.buildSnackBar(
                  content: const Text('Erro ao listar vagas de estacionamento'),
                  backgroundColor: Colors.red,
                  label: '',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            }
          },
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

  Widget _buildSuccessState(List<ParkingSpaceModel> parkingSpaceList) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      itemCount: parkingSpaceList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 100,
      ),
      itemBuilder: (context, index) {
        final parkingSpace = parkingSpaceList[index];
        return ParkingSpaceCard(
          parkingSpaceModel: parkingSpace,
          isLast: index == parkingSpaceList.length - 1,
          isSecondLast: index == parkingSpaceList.length - 2,
          onClick: (parkingSpaceModel) async {
            await showModalBottomSheet<void>(
              context: context,
              builder: (context) {
                return const ParkingSpaceTicket();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildFailureState() => const SizedBox.shrink();
}
