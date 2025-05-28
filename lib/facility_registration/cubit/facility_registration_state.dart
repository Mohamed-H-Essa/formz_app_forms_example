// ignore_for_file: equal_keys_in_map

import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/debug_extension.dart';
import 'package:formz_example/shared/enum/form_field_enum.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/generic_inputs/generic_input.dart';
import 'package:formz_example/shared/models/formz_state.dart';
import 'package:formz_example/shared/models/step_state.dart';
import 'package:formz_example/shared/validators/validators.dart';

class FacilityRegistrationFormzState<StepState extends FormzStepBaseState>
    extends FormzBaseState<StepState> {
  const FacilityRegistrationFormzState({
    required super.steps,
    required super.currentStepIndex,
    required super.status,
    required super.erroneousSteps,
  });

  @override
  factory FacilityRegistrationFormzState.init() {
    return FacilityRegistrationFormzState(
      steps: [
        CustomStep1(stepId: 'step1', inputs: _initStep1Inputs()) as StepState,
        FormzStepState(stepId: 'step2', inputs: _initStep2Inputs())
            as StepState,
        FormzStepState(stepId: 'step3', inputs: _initStep3Inputs())
            as StepState,
      ],
      currentStepIndex: 0,
      status: FormzSubmissionStatus.initial,
      erroneousSteps: const [],
    );
  }

  /// Initialize Step 1 (Personal Information) with predefined fields and validators
  static Map<FormFieldEnum, GenericInput> _initStep1Inputs() {
    return {
      FormFieldEnum.firstName: const GenericInput<String>.pure(
        value: '',
        validators: [requiredValidator],
        uiType: UiTypeEnum.simpleTextField,
      ),
      FormFieldEnum.lastName: const GenericInput<String>.pure(
        value: 'first',
        validators: [requiredValidator],
        uiType: UiTypeEnum.simpleTextField,
      ),
      FormFieldEnum.dob: const GenericInput<String>.pure(
        value: '',
        validators: [
          requiredValidator,
          _dobValidator,
        ],
        uiType: UiTypeEnum.simpleTextField,
      ),
      FormFieldEnum.email: const GenericInput<String>.pure(
        value: '',
        validators: [requiredValidator, emailValidator],
        uiType: UiTypeEnum.simpleTextField,
      ),
      // FormFieldEnum.password: GenericInput<String>.pure(
      //   value: '',
      //   validators: [
      //     requiredValidator,
      //     minLengthValidator(8),
      //     hasNumberValidator,
      //     hasSpecialCharValidator,
      //   ],
      // ),
      // FormFieldEnum.confirmPassword: GenericInput<String>.pure(
      //   value: '',
      //   validators: [requiredValidator, _confirmPasswordValidator],
      // ),
      // FormFieldEnum.age: GenericInput<String>.pure(
      //   value: '20',
      //   validators: [
      //     requiredValidator,
      //     _ageValidator,
      //   ],
      // ),
      // Complex form fields
      // FormFieldEnum.firstName: const GenericInput<String>.pure(
      //   value: '',
      //   validators: [requiredValidator],
      // ),
      FormFieldEnum.lastName: const GenericInput<String>.pure(
        value: 'sec',
        validators: [requiredValidator],
        uiType: UiTypeEnum.simpleTextField,
      ),
      FormFieldEnum.dob: const GenericInput<String>.pure(
        value: '',
        validators: [
          requiredValidator,
          _dobValidator,
        ],
        uiType: UiTypeEnum.simpleTextField,
      ),
    };
  }

  /// Initialize Step 2 (Contact Details) with predefined fields and validators
  static Map<FormFieldEnum, GenericInput> _initStep2Inputs() {
    return {
      FormFieldEnum.email: const GenericInput<String>.pure(
        value: '',
        validators: [requiredValidator, emailValidator],
        uiType: UiTypeEnum.simpleTextField,
      ),
      FormFieldEnum.phone: const GenericInput<String>.pure(
        value: '',
        validators: [requiredValidator, phoneValidator],
        uiType: UiTypeEnum.simpleTextField,
      ),
      FormFieldEnum.address: const GenericInput<String>.pure(
        value: '',
        validators: [], // Optional field, no validators
        uiType: UiTypeEnum.simpleTextField,
      ),
    };
  }

  /// Initialize Step 3 (Preferences) with predefined fields and validators
  static Map<FormFieldEnum, GenericInput> _initStep3Inputs() {
    return {
      FormFieldEnum.notificationChannel: const GenericInput<String>.pure(
        value: '',
        validators: [requiredValidator],
        uiType: UiTypeEnum.simpleTextField,
      ),
      FormFieldEnum.termsAccepted: const GenericInput<bool>.pure(
        value: false,
        validators: [_termsValidator],
        uiType: UiTypeEnum.simpleTextField,
      ),
    };
  }

  /// Date of birth validator
  static String? _dobValidator(String value) {
    if (value.isEmpty) return null; // Let required validator handle this
    final datePattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!datePattern.hasMatch(value)) {
      return 'Use format: DD/MM/YYYY';
    }
    return null;
  }

  /// Terms and conditions validator
  static String? _termsValidator(bool value) {
    return value != true ? 'You must accept the terms and conditions' : null;
  }

  /// Age validator
  static String? _ageValidator(String value) {
    if (value.isEmpty) return null; // Let required validator handle this
    final age = int.tryParse(value);
    if (age == null) return 'Please enter a valid number';
    return numberRangeValidator(age, 18, 120);
  }

  /// Confirm password validator (dynamic validation handled in updateInput)
  static String? _confirmPasswordValidator(String value) {
    // This will be updated dynamically when password changes
    return null;
  }

  // FormzStepState get currentStep {
  //   return steps[currentStepIndex - 1];
  //   // switch (currentStepIndex) {
  //   //   case 1:
  //   //     return step1;
  //   //   case 2:
  //   //     return step2;
  //   //   case 3:
  //   //     return step3;
  //   //   default:
  //   //     return step1;
  //   // }
  // }

  // bool get isAllValid {
  //   // return true;
  //   return !steps.any((step) => step.isNotValid
  //     ..debug('validator step No. ${step.stepId} is not valid: '));
  //   // if (step1.isValid && step2.isValid && step3.isValid) {
  //   //   return true;
  //   // } else {
  //   //   return false;
  //   // }
  // }

  bool isPersonalInfoValid(FacilityRegistrationFormzState state) {
    return state.steps[0].inputs[FormFieldEnum.firstName]?.isValid == true &&
        state.steps[0].inputs[FormFieldEnum.lastName]?.isValid == true &&
        state.steps[0].inputs[FormFieldEnum.dob]?.isValid == true;
  }

  bool isContactDetailsValid(FacilityRegistrationFormzState state) {
    return state.steps[1].inputs[FormFieldEnum.email]?.isValid == true &&
        state.steps[1].inputs[FormFieldEnum.phone]?.isValid == true;
  }

  bool isPreferencesValid(FacilityRegistrationFormzState state) {
    'isPreferencesValid : '.debug();
    return (state.steps[2].inputs[FormFieldEnum.notificationChannel]?.isValid ==
        true)
      ..debug('isPreferencesValid : ');
  }

  @override
  List<Object?> get props => [steps, currentStepIndex, status, erroneousSteps];

  @override
  FacilityRegistrationFormzState<StepState> copyWith(
      {StepState? currentStep,
      List<StepState>? steps,
      int? currentStepIndex,
      FormzSubmissionStatus? status,
      List<int>? erroneousSteps}) {
    return FacilityRegistrationFormzState(
      steps: steps ??
          (currentStep == null
              ? this.steps
              : (List<StepState>.from(this.steps)
                ..[this.currentStepIndex] = currentStep)),
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      status: status ?? this.status,
      erroneousSteps: erroneousSteps ?? this.erroneousSteps,
    );
  }
}

class CustomStep1 extends FormzStepState {
  const CustomStep1({required super.stepId, required super.inputs});

  @override
  Map<String, dynamic> toJson() {
    return {'step1': super.toJson()};
  }
}

class FormzStepState extends FormzStepBaseState {
  const FormzStepState({
    required super.stepId,
    required super.inputs,
    super.status = FormzSubmissionStatus.initial,
    super.apiJsonValidator,
    super.errorMessage,
  });

  @override
  FormzStepState copyWith({
    String? stepId,
    Map<FormFieldEnum, GenericInput>? inputs,
    FormzSubmissionStatus? status,
    ValueGetter<Map<String, dynamic> Function()?>? apiJsonValidator,
    String? errorMessage,
  }) {
    return FormzStepState(
      stepId: stepId ?? this.stepId,
      inputs: inputs ?? this.inputs,
      status: status ?? this.status,
      apiJsonValidator:
          apiJsonValidator != null ? apiJsonValidator() : this.apiJsonValidator,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
