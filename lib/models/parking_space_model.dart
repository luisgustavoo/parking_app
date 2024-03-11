import 'dart:convert';

import 'package:parking_app/models/vehicles_model.dart';

class ParkingSpaceModel {
  ParkingSpaceModel({
    required this.number,
    required this.type,
    required this.occupied,
    this.vehicle,
    this.id,
  });

  factory ParkingSpaceModel.fromMap(Map<String, dynamic> map) {
    return ParkingSpaceModel(
      id: map['id'] as int,
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

  final int? id;
  final int number;
  final VehiclesType type;
  final bool occupied;
  final VehiclesModel? vehicle;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'type': type.toStringType(),
      'occupied': occupied,
      'vehicle': vehicle?.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  ParkingSpaceModel copyWith({
    int? id,
    int? number,
    VehiclesType? type,
    bool? occupied,
    VehiclesModel? vehicle,
  }) {
    return ParkingSpaceModel(
      id: id ?? this.id,
      number: number ?? this.number,
      type: type ?? this.type,
      occupied: occupied ?? this.occupied,
      vehicle: vehicle ?? this.vehicle,
    );
  }
}
