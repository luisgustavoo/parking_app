import 'dart:convert';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    required this.name,
    required this.cpf,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      cpf: map['cpf'] as String,
      password: map['password'] as String,
    );
  }

  factory UserModel.fromJson(String source) => UserModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  final int id;
  final String name;
  final String cpf;
  final String password;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'cpf': cpf,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        id,
        name,
        cpf,
        password,
      ];
}
