import 'package:flutter/services.dart';

class PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // 1. Strip out everything that isn't a number
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    // 2. Check the raw digit count to determine grouping format
    if (text.length <= 8) {
      // 8-digit format (e.g., 12 123 456) -> Breaks at index 1 and 4
      for (int i = 0; i < text.length; i++) {
        buffer.write(text[i]);
        if (i == 1 || i == 4) {
          if (i != text.length - 1) buffer.write(' ');
        }
      }
    } else {
      // 9-digit format (e.g., 97 123 45 67) -> Breaks at index 1, 4, and 6
      for (int i = 0; i < text.length; i++) {
        buffer.write(text[i]);
        if (i == 1 || i == 4 || i == 6) {
          if (i != text.length - 1) buffer.write(' ');
        }
      }
    }

    final string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

class CheckPasswordStrength {
  /// Returns a strength score from 0 to 4 based on password complexity
  static int calculateStrength(String password) {
    if (password.isEmpty) return 0;

    int score = 0;

    // 1. Check length
    if (password.length >= 8) score++;

    // 2. Contains lowercase & uppercase
    if (password.contains(RegExp(r'[a-z]')) && password.contains(RegExp(r'[A-Z]'))) {
      score++;
    }

    // 3. Contains digits
    if (password.contains(RegExp(r'[0-9]'))) score++;

    // 4. Contains special characters
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_]'))) score++;

    // Ensure score is at least 1 if password isn't empty
    return score == 0 ? 1 : score;
  }
}