import 'package:flutter/services.dart';

class MaxValueFormatter extends TextInputFormatter {
  final int maxValue;

  MaxValueFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      int value = int.parse(newValue.text);
      if (value > maxValue) {
        // Jika nilai lebih besar dari nilai maksimum, kembalikan nilai maksimum
        return TextEditingValue(
          text: maxValue.toString(),
          selection:
              TextSelection.collapsed(offset: maxValue.toString().length),
        );
      }
    }
    // Jika memenuhi batasan, biarkan nilai tetap
    return newValue;
  }
}
