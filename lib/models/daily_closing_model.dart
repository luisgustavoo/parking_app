import 'dart:convert';

class DailyClosingModel {
  DailyClosingModel({
    required this.amount,
    required this.date,
    this.id,
  });

  factory DailyClosingModel.fromMap(Map<String, dynamic> map) {
    return DailyClosingModel(
      id: map['id'] != null ? map['id'] as int : null,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'].toString()),
    );
  }

  factory DailyClosingModel.fromJson(String source) =>
      DailyClosingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final int? id;
  final double amount;
  final DateTime date;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'date': DateTime(date.year, date.month, date.day).toString(),
    };
  }

  String toJson() => json.encode(toMap());
}
