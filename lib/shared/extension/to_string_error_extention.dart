import 'package:formz_example/shared/enum/input_error_enum.dart';

import 'package:flutter/material.dart';

extension InputErrorToString on InputErrorEnum {
  String tr(BuildContext context) {
    switch (this) {
      case InputErrorEnum.required:
        return 'This field is required';
      case InputErrorEnum.tooShort:
        return 'Input is too short';
      case InputErrorEnum.tooLong:
        return 'Input is too long';
      case InputErrorEnum.outOfRange:
        return 'Value is out of range';
      case InputErrorEnum.invalidFormat:
        return 'Invalid format';
      case InputErrorEnum.shouldContainSpecialCharacter:
        return 'Must contain at least one special character';
      case InputErrorEnum.shouldContainUppercase:
        return 'Must contain at least one uppercase letter';
      case InputErrorEnum.shouldContainLowercase:
        return 'Must contain at least one lowercase letter';
      case InputErrorEnum.shouldContainNumber:
        return 'Must contain at least one number';
      case InputErrorEnum.invalidEmail:
        return 'Invalid email address';
      case InputErrorEnum.invalidPhoneNumber:
        return 'Invalid phone number';
      case InputErrorEnum.passwordMismatch:
        return 'Passwords do not match';
      case InputErrorEnum.alreadyExists:
        return 'Already exists';
      case InputErrorEnum.notFound:
        return 'Not found';
      case InputErrorEnum.invalidDate:
        return 'Invalid date';
      case InputErrorEnum.futureDateNotAllowed:
        return 'Future date is not allowed';
      case InputErrorEnum.pastDateNotAllowed:
        return 'Past date is not allowed';
    }
  }
}
