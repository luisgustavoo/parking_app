import 'dart:convert';

import 'package:parking_app/models/vehicles_model.dart';

class ParkingSpaceModel {
  ParkingSpaceModel({
    required this.number,
    required this.type,
    required this.occupied,
  });

  factory ParkingSpaceModel.fromMap(Map<String, dynamic> map) {
    return ParkingSpaceModel(
      number: map['number'] as int,
      type: (map['type'] as String).toType(),
      occupied: map['occupied'] as bool,
    );
  }

  factory ParkingSpaceModel.fromJson(String source) =>
      ParkingSpaceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int number;
  final VehiclesType type;
  bool occupied = false;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'type': type.toString(),
      'occupied': occupied,
    };
  }

  String toJson() => json.encode(toMap());
}
