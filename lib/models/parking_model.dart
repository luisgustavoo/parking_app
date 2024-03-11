import 'dart:convert';

class ParkingModel {
  ParkingModel({
    required this.id,
    required this.name,
    required this.address,
    required this.numberParkingSpaces,
    required this.hourlyRate,
  });

  factory ParkingModel.fromMap(Map<String, dynamic> map) {
    return ParkingModel(
      id: map['id'] as int,
      name: map['name'] as String,
      address: map['address'] as String,
      numberParkingSpaces: map['numberParkingSpaces'] as int,
      hourlyRate: map['hourlyRate'] as double,
    );
  }

  factory ParkingModel.fromJson(String source) =>
      ParkingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int id;
  final String name;
  final String address;
  final int numberParkingSpaces;
  final double hourlyRate;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'numberParkingSpaces': numberParkingSpaces,
      'hourlyRate': hourlyRate,
    };
  }

  String toJson() => json.encode(toMap());
}
