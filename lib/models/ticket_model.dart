import 'dart:convert';

import 'package:equatable/equatable.dart';

class TicketModel extends Equatable {
  const TicketModel({
    required this.entryDataTime,
    required this.vehiclePlate,
    required this.parkingSpaceId,
    this.id,
    this.departureDateTime,
    this.amountPaid,
  });

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] != null ? map['id'] as int : null,
      entryDataTime:
          DateTime.fromMillisecondsSinceEpoch(map['entry_data_time'] as int),
      departureDateTime: map['departure_date_time'] != null
          ? DateTime(
              map['departure_date_time'] as int,
            )
          : null,
      vehiclePlate: map['vehicle_plate'] as String,
      parkingSpaceId: map['parking_space_id'] as int,
      amountPaid:
          map['amount_paid'] != null ? map['amount_paid'] as double : null,
    );
  }

  factory TicketModel.fromJson(String source) =>
      TicketModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int? id;
  final DateTime entryDataTime;
  final DateTime? departureDateTime;
  final String vehiclePlate;
  final int parkingSpaceId;
  final double? amountPaid;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'entry_data_time': entryDataTime.millisecondsSinceEpoch,
      'departure_date_time': departureDateTime?.toLocal(),
      'vehicle_plate': vehiclePlate,
      'parking_space_id': parkingSpaceId,
      'amount_paid': amountPaid,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props {
    return [
      id,
      entryDataTime,
      departureDateTime,
      vehiclePlate,
      parkingSpaceId,
      amountPaid,
    ];
  }
}
