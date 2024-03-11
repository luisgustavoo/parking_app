import 'dart:convert';

import 'package:equatable/equatable.dart';

enum VehiclesType { car, motorcycle }

extension StringToEnum on String {
  VehiclesType toType() {
    switch (toLowerCase()) {
      case 'car':
        return VehiclesType.car;
      case 'motorcycle':
        return VehiclesType.motorcycle;
      default:
        throw ArgumentError('Invalid string: $this');
    }
  }
}

extension EnumToString on VehiclesType {
  String toStringType() {
    switch (this) {
      case VehiclesType.car:
        return 'car';
      case VehiclesType.motorcycle:
        return 'motorcycle';
      default:
        throw ArgumentError('Invalid type: $this');
    }
  }
}

class VehiclesModel extends Equatable {
  const VehiclesModel({
    required this.plate,
    required this.model,
    required this.color,
    required this.type,
    required this.owner,
    this.id,
  });

  factory VehiclesModel.fromMap(Map<String, dynamic> map) {
    return VehiclesModel(
      id: map['id'] != null ? map['id'] as int : null,
      plate: map['plate'] as String,
      model: map['model'] as String,
      color: map['color'] as String,
      type: (map['type'] as String).toType(),
      owner: map['owner'] as String,
    );
  }

  factory VehiclesModel.fromJson(String source) =>
      VehiclesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int? id;
  final String plate;
  final String model;
  final String color;
  final VehiclesType type;
  final String owner;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'plate': plate,
      'model': model,
      'color': color,
      'type': type.toStringType(),
      'owner': owner,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        id,
        plate,
        model,
        color,
        type,
        owner,
      ];
}
