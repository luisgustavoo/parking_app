import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parking_app/core/ui/extensions/screen_extension.dart';
import 'package:parking_app/core/ui/extensions/theme_extension.dart';
import 'package:parking_app/core/ui/widgets/gap.dart';
import 'package:parking_app/models/parking_space_model.dart';
import 'package:parking_app/models/vehicles_model.dart';

class ParkingSpaceCard extends StatefulWidget {
  const ParkingSpaceCard({
    required this.parkingSpaceModel,
    required this.isLast,
    required this.isSecondLast,
    this.onClick,
    this.isSelected = false,
    super.key,
  });

  final ParkingSpaceModel parkingSpaceModel;
  final bool isLast;
  final bool isSecondLast;
  final void Function(ParkingSpaceModel parkingSpaceModel, int number)? onClick;
  final bool isSelected;

  @override
  State<ParkingSpaceCard> createState() => _ParkingSpaceCardState();
}

class _ParkingSpaceCardState extends State<ParkingSpaceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onClick != null) {
          widget.onClick
              ?.call(widget.parkingSpaceModel, widget.parkingSpaceModel.number);
        }
      },
      child: Container(
        margin: EdgeInsets.only(
          left: widget.parkingSpaceModel.number.isEven ? 32.w : 0,
          right: widget.parkingSpaceModel.number.isOdd ? 32.w : 0,
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
            isSelected: widget.isSelected,
          ),
        ),
      ),
    );
  }
}

class _BuildParkingSpace extends StatelessWidget {
  const _BuildParkingSpace({
    required this.parkingSpaceModel,
    required this.isSelected,
  });

  final ParkingSpaceModel parkingSpaceModel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return switch (parkingSpaceModel.occupied) {
      true => _buildParkingSpaceOccupied(context),
      _ => _buildParkingSpaceEmpty(context)
    };
  }

  Widget _buildParkingSpaceEmpty(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        border: isSelected
            ? Border.all(
                color: context.primaryColorDark,
              )
            : null,
        color: isSelected ? context.primaryColorLight : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Vaga ${parkingSpaceModel.number}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          Text(
            '(${parkingSpaceModel.type.toStringTypeTranslate()})',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const Text(
            'Livre',
            style: TextStyle(
              color: Colors.green,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingSpaceOccupied(BuildContext context) {
    return parkingSpaceModel.number.isOdd
        ? Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(
                      color: context.primaryColor,
                    )
                  : null,
              color: isSelected ? context.primaryColorLight : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Prop: ${parkingSpaceModel.vehicle?.owner}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Row(
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
                    SvgPicture.asset(
                      'assets/icon/icon_car_left.svg',
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        parkingSpaceModel.vehicle?.model ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            decoration: BoxDecoration(
              border: isSelected
                  ? Border.all(
                      color: context.primaryColor,
                    )
                  : null,
              color: isSelected ? context.primaryColorLight : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Prop: ${parkingSpaceModel.vehicle?.owner}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icon/icon_car_right.svg',
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
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        parkingSpaceModel.vehicle?.model ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
