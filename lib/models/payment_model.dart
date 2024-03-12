import 'dart:convert';

import 'package:equatable/equatable.dart';

enum PaymentType { card, money }

extension StringToEnum on String {
  PaymentType toType() {
    switch (toLowerCase()) {
      case 'card':
        return PaymentType.card;
      case 'money':
        return PaymentType.money;
      default:
        throw ArgumentError('Invalid string: $this');
    }
  }
}

extension EnumToString on PaymentType {
  String toStringType() {
    switch (this) {
      case PaymentType.card:
        return 'card';
      case PaymentType.money:
        return 'money';
      default:
        throw ArgumentError('Invalid string: $this');
    }
  }
}

class PaymentModel extends Equatable {
  const PaymentModel({
    required this.paymentType,
    required this.value,
    required this.ticketId,
    this.id,
  });

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: map['id'] != null ? map['id'] as int : null,
      paymentType: (map['payment_type'] as String).toType(),
      value: map['value'] as double,
      ticketId: map['ticket_id'] as int,
    );
  }

  factory PaymentModel.fromJson(String source) =>
      PaymentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int? id;
  final PaymentType paymentType;
  final double value;
  final int ticketId;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'payment_type': paymentType.toStringType(),
      'value': value,
      'ticket_id': ticketId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  List<Object?> get props => [
        id,
        paymentType,
        value,
        ticketId,
      ];
}
