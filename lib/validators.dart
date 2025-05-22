/// Common form validators
library validators;

/// Validates that a field is not empty
String? requiredValidator(String value) =>
    value.isEmpty ? 'This field is required' : null;

/// Validates that a field contains a valid email address
String? emailValidator(String value) =>
    RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value) ? null : 'Invalid email';

/// Creates a validator that ensures a string has at least the specified length
String? Function(String) minLengthValidator(int minLength) {
  return (String value) =>
      value.length >= minLength ? null : 'Minimum length is $minLength';
}

/// Creates a validator that ensures a string is no longer than the specified length
String? Function(String) maxLengthValidator(int maxLength) {
  return (String value) =>
      value.length <= maxLength ? null : 'Maximum length is $maxLength';
}

/// Validates that a field contains only digits
String? numericValidator(String value) =>
    RegExp(r'^\d+$').hasMatch(value) ? null : 'Only digits are allowed';

/// Validates that a field contains at least one uppercase letter,
/// one lowercase letter, one digit and one special character
String? strongPasswordValidator(String value) {
  if (value.isEmpty) return null;

  final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
  final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
  final hasDigit = RegExp(r'\d').hasMatch(value);
  final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

  if (!hasUppercase || !hasLowercase || !hasDigit || !hasSpecialChar) {
    return 'Password must contain uppercase, lowercase, digit and special character';
  }

  return null;
}
