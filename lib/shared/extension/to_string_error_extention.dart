import 'package:flutter/material.dart';
import 'package:formz_example/shared/enum/input_error_enum.dart';

extension InputErrorToString on InputErrorEnum {
  String tr(BuildContext context) {
    switch (this) {
      case InputErrorEnum.required:
        return "Field is required";
      case InputErrorEnum.tooShort:
        return "Input is too short";
      case InputErrorEnum.tooLong:
        return "Input is too long";
      case InputErrorEnum.outOfRange:
        return "Value is out of range";
      case InputErrorEnum.invalidFormat:
        return "Invalid format";
      case InputErrorEnum.shouldContainSpecialCharacter:
        return "Should contain special character";
      case InputErrorEnum.shouldContainUppercase:
        return "Should contain uppercase letter";
      case InputErrorEnum.shouldContainLowercase:
        return "Should contain lowercase letter";
      case InputErrorEnum.shouldContainNumber:
        return "Should contain number";
      case InputErrorEnum.invalidEmail:
        return "Invalid email address";
      case InputErrorEnum.invalidPhoneNumber:
        return "Invalid phone number";
      case InputErrorEnum.passwordMismatch:
        return "Password mismatch";
      case InputErrorEnum.alreadyExists:
        return "Already exists";
      case InputErrorEnum.notFound:
        return "Not found";
      case InputErrorEnum.invalidDate:
        return "Invalid date";
      case InputErrorEnum.futureDateNotAllowed:
        return "Future date not allowed";
      case InputErrorEnum.pastDateNotAllowed:
        return "Past date not allowed";
      case InputErrorEnum.weakPassword:
        return "Password is too weak";
      case InputErrorEnum.multiFiles:
        return "Multiple files error";
      case InputErrorEnum.arabicOnly:
        return "Arabic only";
      case InputErrorEnum.mustBeFourParts:
        return "Full name validation error";
    }
  }
}
