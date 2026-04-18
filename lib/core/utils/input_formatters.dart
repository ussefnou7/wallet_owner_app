import 'package:flutter/services.dart';

class PositiveAmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }

    final valid = RegExp(r'^\d*\.?\d{0,2}$').hasMatch(text);
    return valid ? newValue : oldValue;
  }
}
