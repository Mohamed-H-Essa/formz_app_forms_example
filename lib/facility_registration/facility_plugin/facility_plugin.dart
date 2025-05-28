import 'package:formz_example/facility_registration/cubit/facility_registration_state.dart';
import 'package:formz_example/facility_registration/keys/registration_input_keys.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/generic_inputs/generic_input.dart';
import 'package:formz_example/shared/models/step_state.dart';
import 'package:formz_example/shared/validators/validators.dart';

List<FormzStepBaseState> facilitySteps = [
  CustomStep1(stepId: 'step1', inputs: _initStep1Inputs()),
  FormzStepState(stepId: 'step2', inputs: _initStep2Inputs()),
  FormzStepState(stepId: 'step3', inputs: _initStep3Inputs()),
];

class CustomStep1 extends FormzStepState {
  const CustomStep1({required super.stepId, required super.inputs});

  @override
  Map<String, dynamic> toJson() {
    return {
      'step1': {'ii': super.toJson()}
    };
  }
}

Map<String, GenericInput> _initStep1Inputs() {
  return {
    RegistrationInputKeys.firstName: const GenericInput<String>.pure(
      value: 'fn',
      validators: [requiredValidator],
      label: 'First Name',
      toJsonKey: 'first_name',
      uiType: UiTypeEnum.simpleTextField,
    ),
    RegistrationInputKeys.lastName: const GenericInput<String>.pure(
      value: 'ln',
      label: 'Last Name',
      toJsonKey: 'last_name',
      validators: [requiredValidator],
      uiType: UiTypeEnum.simpleTextField,
    ),
    // RegistrationInputKeys.dob: const GenericInput<String>.pure(
    //   value: '',
    //   validators: [
    //     requiredValidator,
    //   ],
    //   uiType: UiTypeEnum.simpleTextField,
    // ),
    // RegistrationInputKeys.email: const GenericInput<String>.pure(
    //   value: '',
    //   validators: [requiredValidator, emailValidator],
    //   uiType: UiTypeEnum.simpleTextField,
    // ),
    // String.password: GenericInput<String>.pure(
    //   value: '',
    //   validators: [
    //     requiredValidator,
    //     minLengthValidator(8),
    //     hasNumberValidator,
    //     hasSpecialCharValidator,
    //   ],
    // ),
    // String.confirmPassword: GenericInput<String>.pure(
    //   value: '',
    //   validators: [requiredValidator, _confirmPasswordValidator],
    // ),
    // String.age: GenericInput<String>.pure(
    //   value: '20',
    //   validators: [
    //     requiredValidator,
    //     _ageValidator,
    //   ],
    // ),
    // Complex form fields
    // String.firstName: const GenericInput<String>.pure(
    //   value: '',
    //   validators: [requiredValidator],
    // ),
    // RegistrationInputKeys.email: const GenericInput<String>.pure(
    //   value: 'sec',
    //   validators: [requiredValidator],
    //   uiType: UiTypeEnum.simpleTextField,
    // ),
    // RegistrationInputKeys.dob: const GenericInput<String>.pure(
    //   value: '',
    //   validators: [
    //     requiredValidator,
    //   ],
    //   uiType: UiTypeEnum.simpleTextField,
    // ),
  };
}

/// Initialize Step 2 (Contact Details) with predefined fields and validators
Map<String, GenericInput> _initStep2Inputs() {
  return {
    RegistrationInputKeys.email: const GenericInput<String>.pure(
      value: 'a@b.c',
      label: 'email',
      id: 'step_2_email',
      validators: [requiredValidator, emailValidator],
      uiType: UiTypeEnum.simpleTextField,
      fromJsonKey: 'email_fromJsonKey',
      toJsonKey: 'email_toJsonKey',
    ),
    RegistrationInputKeys.phone: const GenericInput<String>.pure(
      value: '0102334434',
      label: 'Phone Number',
      toJsonKey: 'phone_number',
      validators: [requiredValidator, phoneValidator],
      uiType: UiTypeEnum.phone,
    ),
    RegistrationInputKeys.address: const GenericInput<String>.pure(
      value: 'address',
      label: 'address',
      toJsonKey: 'address',
      validators: [], // Optional field, no validators
      uiType: UiTypeEnum.expandedText,
    ),
  };
}

/// Initialize Step 3 (Preferences) with predefined fields and validators
Map<String, GenericInput> _initStep3Inputs() {
  return {
    RegistrationInputKeys.notificationChannel: const GenericInput<String>.pure(
      value: '',
      validators: [requiredValidator],
      toJsonKey: 'notification_channel',
      uiType: UiTypeEnum.multiInput,
    ),
    RegistrationInputKeys.termsAccepted: const GenericInput<bool>.pure(
      value: false,
      validators: [],
      toJsonKey: 'terms_accepted',
      uiType: UiTypeEnum.checkbox,
    ),
  };
}
