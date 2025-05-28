// ignore_for_file: equal_keys_in_map

import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/facility_registration/facility_plugin/facility_plugin.dart';
import 'package:formz_example/facility_registration/keys/registration_input_keys.dart';
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
      steps: facilitySteps as List<StepState>,
      // steps: [
      //   CustomStep1(stepId: 'step1', inputs: _initStep1Inputs()) as StepState,
      //   FormzStepState(stepId: 'step2', inputs: _initStep2Inputs())
      //       as StepState,
      //   FormzStepState(stepId: 'step3', inputs: _initStep3Inputs())
      //       as StepState,
      // ],
      currentStepIndex: 0,
      status: FormzSubmissionStatus.initial,
      erroneousSteps: const [],
    );
  }

  /// Initialize Step 1 (Personal Information) with predefined fields and validators

  bool isPersonalInfoValid(FacilityRegistrationFormzState state) {
    return state.steps[0].inputs[RegistrationInputKeys.firstName]?.isValid ==
            true &&
        state.steps[0].inputs[RegistrationInputKeys.lastName]?.isValid ==
            true &&
        state.steps[0].inputs[RegistrationInputKeys.dob]?.isValid == true;
  }

  bool isContactDetailsValid(FacilityRegistrationFormzState state) {
    return state.steps[1].inputs[RegistrationInputKeys.email]?.isValid ==
            true &&
        state.steps[1].inputs[RegistrationInputKeys.phone]?.isValid == true;
  }

  bool isPreferencesValid(FacilityRegistrationFormzState state) {
    return (state.steps[2].inputs[RegistrationInputKeys.notificationChannel]
            ?.isValid ==
        true);
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
    Map<String, GenericInput>? inputs,
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
