import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_app/core/rest_client/dio_rest_client.dart';
import 'package:parking_app/core/rest_client/logs/log_impl.dart';
import 'package:parking_app/core/ui/extensions/screen_extension.dart';
import 'package:parking_app/core/ui/widgets/parking_loading_widget.dart';
import 'package:parking_app/core/ui/widgets/parking_snack_bar.dart';
import 'package:parking_app/core/ui/widgets/parking_space_card.dart';
import 'package:parking_app/models/parking_space_model.dart';
import 'package:parking_app/models/vehicles_model.dart';
import 'package:parking_app/modules/parking_space/bloc/parking_space_bloc.dart';
import 'package:parking_app/modules/parking_space/repository/parking_space_repository.dart';
import 'package:parking_app/modules/ticket/bloc/register/ticket_register_bloc.dart';
import 'package:parking_app/modules/ticket/bloc/ticket_bloc.dart';
import 'package:parking_app/modules/ticket/bloc/update/ticket_update_bloc.dart';
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
  int? _parkingSpaceNumber;
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: BlocConsumer<ParkingSpaceBloc, ParkingSpaceState>(
          listener: (context, state) {
            if (state.status == ParkingSpaceStatus.failure) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                ParkingSnackBar.buildSnackBar(
                  content: const Text('Erro ao listar vagas de estacionamento'),
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
                return _buildSuccessState(state.parkingSpaceList);
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

  Widget _buildSuccessState(List<ParkingSpaceModel>? parkingSpaceList) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      itemCount: parkingSpaceList!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 100.h,
      ),
      itemBuilder: (context, index) {
        final parkingSpace = parkingSpaceList[index];
        return ParkingSpaceCard(
          parkingSpaceModel: parkingSpace,
          isLast: index == parkingSpaceList.length - 1,
          isSecondLast: index == parkingSpaceList.length - 2,
          selected: _parkingSpaceNumber == parkingSpace.number,
          onClick: (parkingSpaceModel, number) async {
            setState(() {
              _parkingSpaceNumber = number;
            });
            switch (parkingSpaceModel.occupied) {
              case true:
                await _registerVehicleDeparture(parkingSpaceModel);
              default:
                await _registerVehicleEntry(parkingSpaceModel);
            }
          },
        );
      },
    );
  }

  Widget _buildFailureState() => const SizedBox.shrink();

  Future<void> _registerVehicleEntry(
    ParkingSpaceModel parkingSpaceModel,
  ) async {
    final parkingSpaceBloc = BlocProvider.of<ParkingSpaceBloc>(context);
    final result =
        await showDialog<({TicketRegisterState state, VehiclesModel vehicle})>(
      context: context,
      builder: (context) {
        return ParkingSpaceTicketProvider(
          parkingSpaceModel: parkingSpaceModel,
        );
      },
    );

    if (result != null) {
      if (result.state is TicketRegisterFailure) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          ParkingSnackBar.buildSnackBar(
            content: const Text('Erro registrar ticket'),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (result.state is TicketRegisterSuccess) {
        final data = <String, dynamic>{
          'occupied': true,
          'vehicle': result.vehicle.toMap(),
        };
        parkingSpaceBloc
          ..add(
            ParkingSpaceUpdateEvent(id: parkingSpaceModel.id!, data: data),
          )
          ..add(ParkingSpaceFindAllEvent());
      }
    }
  }

  Future<void> _registerVehicleDeparture(
    ParkingSpaceModel parkingSpaceModel,
  ) async {
    final parkingSpaceBloc = BlocProvider.of<ParkingSpaceBloc>(context);
    final ticketBloc = BlocProvider.of<TicketBloc>(context);

    final result = await showModalBottomSheet<TicketUpdateState>(
      context: context,
      builder: (context) {
        return ParkingSpaceTicketProvider(
          parkingSpaceModel: parkingSpaceModel,
        );
      },
    );

    if (result != null) {
      if (result is TicketUpdateSuccess) {
        final data = <String, dynamic>{
          'occupied': false,
          'vehicle': null,
        };
        parkingSpaceBloc
          ..add(
            ParkingSpaceUpdateEvent(id: parkingSpaceModel.id!, data: data),
          )
          ..add(ParkingSpaceFindAllEvent());

        await Future<void>.delayed(const Duration(milliseconds: 200))
            .whenComplete(() {
          ticketBloc.add(
            TicketFindAllEvent(),
          );
        });
      }

      if (result is TicketUpdateFailure) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          ParkingSnackBar.buildSnackBar(
            content: const Text('Erro finalizar ticket'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
