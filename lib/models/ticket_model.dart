import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:parking_app/models/payment_model.dart';

class TicketModel extends Equatable {
  const TicketModel({
    required this.entryDataTime,
    required this.vehiclePlate,
    required this.parkingSpaceId,
    this.id,
    this.departureDateTime,
    this.amountPaid,
    this.paymentType,
  });

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      id: map['id'] != null ? map['id'] as int : null,
      entryDataTime: DateTime.parse(map['entry_data_time'] as String),
      departureDateTime: map['departure_date_time'] != null
          ? DateTime.parse(
              map['departure_date_time'] as String,
            )
          : null,
      vehiclePlate: map['vehicle_plate'] as String,
      parkingSpaceId: map['parking_space_id'] as int,
      amountPaid:
          map['amount_paid'] != null ? map['amount_paid'] as double : null,
      paymentType: map['payment_type']?.toString().toType(),
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
  final PaymentType? paymentType;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'entry_data_time': entryDataTime.toLocal().toString(),
      'departure_date_time': departureDateTime?.toLocal().toString(),
      'vehicle_plate': vehiclePlate,
      'parking_space_id': parkingSpaceId,
      'amount_paid': amountPaid,
      'payment_type': paymentType?.toStringType(),
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
      paymentType,
    ];
  }
}
