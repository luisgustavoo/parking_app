// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:parking_app/models/vehicles_model.dart';

class ParkingSpaceModel {
  ParkingSpaceModel({
    required this.number,
    required this.type,
    required this.occupied,
    this.vehicle,
  });

  factory ParkingSpaceModel.fromMap(Map<String, dynamic> map) {
    return ParkingSpaceModel(
      number: map['number'] as int,
      type: (map['type'] as String).toType(),
      occupied: map['occupied'] as bool,
      vehicle: map['vehicle'] != null
          ? VehiclesModel.fromMap(map['vehicle'] as Map<String, dynamic>)
          : null,
    );
  }

  factory ParkingSpaceModel.fromJson(String source) =>
      ParkingSpaceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int number;
  final VehiclesType type;
  final bool occupied;
  final VehiclesModel? vehicle;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'type': type.toStringType(),
      'occupied': occupied,
      'vehicle': vehicle?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  ParkingSpaceModel copyWith({
    int? number,
    VehiclesType? type,
    bool? occupied,
    VehiclesModel? vehicle,
  }) {
    return ParkingSpaceModel(
      number: number ?? this.number,
      type: type ?? this.type,
      occupied: occupied ?? this.occupied,
      vehicle: vehicle ?? this.vehicle,
    );
  }
}
