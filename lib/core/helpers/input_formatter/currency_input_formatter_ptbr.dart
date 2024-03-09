import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatterPtBr extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    try {
      double.parse(
        newValue.text
            .replaceAll('.', '')
            .replaceAll(',', '')
            .replaceAll(r'R$', ''),
      );
    } on FormatException {
      return newValue;
    }

    // Se eu digitei apenas um número
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    final value = double.parse(
      newValue.text
          .replaceAll('.', '')
          .replaceAll(',', '')
          .replaceAll(r'R$', ''),
    );

    // Pega o valor e divide por 100
    // Ex: Se eu digitar 12, eu de mostrar 0,12
    final result = NumberFormat.currency(
      locale: 'pt-BR',
      symbol: r'R$',
      decimalDigits: 2,
    ).format(value / 100);

    return newValue.copyWith(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
