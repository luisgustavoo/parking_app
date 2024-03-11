import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parking_app/core/ui/widgets/gap.dart';
import 'package:parking_app/models/parking_space_model.dart';

class ParkingSpaceCard extends StatefulWidget {
  const ParkingSpaceCard({
    required this.parkingSpaceModel,
    required this.isLast,
    required this.isSecondLast,
    this.onClick,
    super.key,
  });

  final ParkingSpaceModel parkingSpaceModel;
  final bool isLast;
  final bool isSecondLast;
  final void Function(ParkingSpaceModel parkingSpaceModel)? onClick;

  @override
  State<ParkingSpaceCard> createState() => _ParkingSpaceCardState();
}

class _ParkingSpaceCardState extends State<ParkingSpaceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onClick != null) {
          widget.onClick?.call(widget.parkingSpaceModel);
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          left: widget.parkingSpaceModel.number.isEven ? 32 : 0,
          right: widget.parkingSpaceModel.number.isOdd ? 32 : 0,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: const BorderSide(color: Colors.grey, width: 5),
            right: const BorderSide(color: Colors.grey, width: 5),
            left: const BorderSide(color: Colors.grey, width: 5),
            bottom: BorderSide(
              width: (widget.isLast || widget.isSecondLast) ? 5.0 : 0,
              color: Colors.grey,
            ),
          ),
        ),
        child: Center(
          child: _BuildParkingSpace(
            parkingSpaceModel: widget.parkingSpaceModel,
          ),
        ),
      ),
    );
  }
}

class _BuildParkingSpace extends StatelessWidget {
  const _BuildParkingSpace({
    required this.parkingSpaceModel,
  });

  final ParkingSpaceModel parkingSpaceModel;

  @override
  Widget build(BuildContext context) {
    return switch (parkingSpaceModel.occupied) {
      true => _buildParkingSpaceOccupied(),
      _ => _buildParkingSpaceEmpty()
    };
  }

  Widget _buildParkingSpaceEmpty() {
    return Text(
      'Vaga ${parkingSpaceModel.number}',
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 20,
      ),
    );
  }

  Widget _buildParkingSpaceOccupied() {
    return parkingSpaceModel.number.isOdd
        ? Row(
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'Vaga ${parkingSpaceModel.number}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gap.horizontal(16),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/icon/icon_car_left.svg',
                  ),
                  Gap.vertical(4),
                  Text(
                    parkingSpaceModel.vehicle?.model ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/icon/icon_car_right.svg',
                  ),
                  Gap.vertical(4),
                  Text(
                    parkingSpaceModel.vehicle?.model ?? '',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Gap.horizontal(16),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'Vaga ${parkingSpaceModel.number}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
  }
}
