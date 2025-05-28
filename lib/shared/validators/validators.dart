import 'package:formz_example/shared/enum/input_error_enum.dart';

InputErrorEnum? requiredValidator(String value) =>
    value.isEmpty ? InputErrorEnum.required : null;

InputErrorEnum? phoneValidator(String value) {
  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
    return InputErrorEnum.invalidPhoneNumber;
  }
  return null;
}

InputErrorEnum? emailValidator(String value) =>
    RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
        ? null
        : InputErrorEnum.invalidEmail;

InputErrorEnum? Function(String) minLengthValidator(int minLength) {
  return (String value) =>
      value.length >= minLength ? null : InputErrorEnum.tooLong;
}

InputErrorEnum? hasNumberValidator(String value) =>
    RegExp(r'[0-9]').hasMatch(value)
        ? null
        : InputErrorEnum.shouldContainNumber;

InputErrorEnum? hasSpecialCharValidator(String value) =>
    RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)
        ? null
        : InputErrorEnum.shouldContainSpecialCharacter;

InputErrorEnum? numberRangeValidator(num value, num min, num max) =>
    (value >= min && value <= max) ? null : InputErrorEnum.outOfRange;

InputErrorEnum? Function(String) patternValidator(
    RegExp pattern, InputErrorEnum errorType) {
  return (String value) => pattern.hasMatch(value) ? null : errorType;
}
