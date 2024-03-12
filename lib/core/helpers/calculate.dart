import 'package:intl/intl.dart';

class Calculate {
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
}
