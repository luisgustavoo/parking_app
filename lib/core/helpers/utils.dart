import 'package:intl/intl.dart';

class Utils {
  Utils._();
  static String differenceInTime({
    required DateTime initialDate,
    DateTime? finalDate,
  }) {
    final difference = (finalDate ?? DateTime.now()).difference(initialDate);

    final hour = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return '${NumberFormat('00').format(hour)}:${NumberFormat('00').format(minutes)}';
  }

  static double amountPaid({
    required double valuePerHour,
    required int minutes,
  }) =>
      (valuePerHour * minutes) / 60;

  static String dateFormat({
    required DateTime date,
    bool showTime = true,
  }) {
    if (showTime) {
      return DateFormat('dd/MM/yyyy HH:mm:ss', 'pt_BR').format(date);
    }

    return DateFormat('dd/MM/yyyy', 'pt_BR').format(date);
  }

  static String currencyFormat({
    required double value,
  }) {
    return NumberFormat.currency(
      locale: 'pt-BR',
      symbol: r'R$',
      decimalDigits: 2,
    ).format(value);
  }
}
