/// Returns an error message if the value is empty, otherwise returns null.
String? requiredValidator(String value) =>
    value.isEmpty ? 'This field is required' : null;

String? phoneValidator(String value) {
  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
    return 'Please enter a valid 10-digit phone number';
  }
  return null;
}

/// Returns an error message if the value is not a valid email, otherwise returns null.
String? emailValidator(String value) =>
    RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value) ? null : 'Invalid email';

/// Creates a validator that ensures a minimum length for a string value.
///
/// Returns a function that returns an error message if the value is less than
/// the minimum length, otherwise returns null.
String? Function(String) minLengthValidator(int minLength) {
  return (String value) =>
      value.length >= minLength ? null : 'Minimum length is $minLength';
}

/// Creates a validator that ensures a string value contains a number.
///
/// Returns a function that returns an error message if the value doesn't
/// contain a number, otherwise returns null.
String? hasNumberValidator(String value) => RegExp(r'[0-9]').hasMatch(value)
    ? null
    : 'Must contain at least one number';

/// Creates a validator that ensures a string value contains a special character.
///
/// Returns a function that returns an error message if the value doesn't
/// contain a special character, otherwise returns null.
String? hasSpecialCharValidator(String value) =>
    RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)
        ? null
        : 'Must contain at least one special character';

/// Creates a validator that ensures a number is within a valid range.
///
/// Returns an error message if the value is not within the range,
/// otherwise returns null.
String? numberRangeValidator(num value, num min, num max) =>
    (value >= min && value <= max)
        ? null
        : 'Value must be between $min and $max';

/// Creates a validator that ensures a string matches a pattern.
///
/// Returns a function that returns an error message if the value doesn't
/// match the pattern, otherwise returns null.
String? Function(String) patternValidator(RegExp pattern, String errorMessage) {
  return (String value) => pattern.hasMatch(value) ? null : errorMessage;
}
