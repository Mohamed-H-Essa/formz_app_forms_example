String? requiredValidator(String value) =>
    value.isEmpty ? 'This field is required' : null;

String? phoneValidator(String value) {
  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
    return 'Please enter a valid 10-digit phone number';
  }
  return null;
}

String? emailValidator(String value) =>
    RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value) ? null : 'Invalid email';

String? Function(String) minLengthValidator(int minLength) {
  return (String value) =>
      value.length >= minLength ? null : 'Minimum length is $minLength';
}

String? hasNumberValidator(String value) => RegExp(r'[0-9]').hasMatch(value)
    ? null
    : 'Must contain at least one number';

String? hasSpecialCharValidator(String value) =>
    RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)
        ? null
        : 'Must contain at least one special character';

String? numberRangeValidator(num value, num min, num max) =>
    (value >= min && value <= max)
        ? null
        : 'Value must be between $min and $max';

String? Function(String) patternValidator(RegExp pattern, String errorMessage) {
  return (String value) => pattern.hasMatch(value) ? null : errorMessage;
}
