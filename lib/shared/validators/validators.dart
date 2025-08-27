import 'package:formz_example/shared/enum/input_error_enum.dart';
import 'package:waste_management/src/widgets/attachment_picker/multi_attachment_selector.dart';

InputErrorEnum? requiredValidator(String value) =>
    value.isEmpty ? InputErrorEnum.required : null;
InputErrorEnum? requiredModelValidator<T>(T value) =>
    value == null ? InputErrorEnum.required : null;

InputErrorEnum? phoneValidator(String value) {
  if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
    return InputErrorEnum.invalidPhoneNumber;
  }
  return null;
}

InputErrorEnum? phoneIfAvailableValidator(String value) {
  if (value.isEmpty) {
    return null;
  }
  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
    return InputErrorEnum.invalidPhoneNumber;
  }
  return null;
}

InputErrorEnum? emailValidator(String value) =>
    RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
        ? null
        : InputErrorEnum.invalidEmail;

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

InputErrorEnum? passwordWeaknessValidator(String value) =>
    RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$').hasMatch(value)
        ? null
        : InputErrorEnum.weakPassword;

InputErrorEnum? useArabicOnlyValidator(String value) =>
    RegExp(r'^[\u0600-\u06FF\s]+$').hasMatch(value)
        ? null
        : InputErrorEnum.arabicOnly;
InputErrorEnum? fullNameValidator(String value) {
  final trimmed = value.trim();

  // Split by one or more spaces
  final parts = trimmed.split(RegExp(r'\s+'));

  return parts.length == 4 ? null : InputErrorEnum.mustBeFourParts;
}

InputErrorEnum? additionalFileValidator(
    List<MultiAttachmentSelectorItem> files) {
  for (int i = 0; i < files.length; i++) {
    if ((files[i].attachment == null) !=
        (files[i].attachmentName.trim() == '')) {
      return InputErrorEnum.multiFiles;
    }
  }
  return null;
}
