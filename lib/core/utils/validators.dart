mixin FormValidators { // <-- Just change 'abstract class' to 'mixin'

  /// Validates that a field is not empty.
  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required.';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required.';
    }
    return null;
  }

  /// Validates a standard email address structure.
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email address is required.';
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  /// Validates password strength (min 8 chars, 1 letter, 1 number).
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    final hasLetters = value.contains(RegExp(r'[a-zA-Z]'));
    final hasDigits = value.contains(RegExp(r'[0-9]'));
    if (!hasLetters || !hasDigits) {
      return 'Password must contain both letters and numbers.';
    }
    return null;
  }

  /// Validates that a confirmation password matches the original password.
  String? validateConfirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password.';
    }
    if (value != originalPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }

  /// Validates basic international or local phone numbers.
  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }

    // 1. Strip out the formatting spaces inserted by PhoneFormatter
    final cleanValue = value.replaceAll(' ', '');

    // 2. Validate against raw digits (8 or 9 digits based on your formatter)
    final phoneRegex = RegExp(r'^[0-9]{8,9}$');

    if (!phoneRegex.hasMatch(cleanValue)) {
      return 'Please enter a valid 8 or 9 digit phone number.';
    }

    return null;
  }
}