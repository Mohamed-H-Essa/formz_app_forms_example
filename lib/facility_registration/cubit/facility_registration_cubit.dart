import 'package:formz/formz.dart';
import 'package:formz_example/debug_extension.dart';
import 'package:formz_example/facility_registration/keys/registration_input_keys.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/enum/input_error_enum.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/generic_inputs/generic_input.dart';
import 'package:formz_example/shared/validators/validators.dart';
import 'facility_registration_state.dart';

class FacilityRegistrationFormCubit
    extends FormCubitBase<FacilityRegistrationFormzState> {
  FacilityRegistrationFormCubit()
      : super(FacilityRegistrationFormzState.init());

  @override
  void updateInput<T>(String fieldKey, T value) {
    if (fieldKey == RegistrationInputKeys.password) {
      _updatePasswordValidator();
    }
    super.updateInput<T>(fieldKey, value);
  }

  _updatePasswordValidator() {
    final confirmPasswordInput =
        state.currentStep.inputs[RegistrationInputKeys.confirmPassword];
    if (confirmPasswordInput != null) {
      final confirmValue = (confirmPasswordInput as GenericInput<String>).value;
      final passwordInput =
          state.currentStep.inputs[RegistrationInputKeys.password];
      final passwordValue = passwordInput != null
          ? (passwordInput as GenericInput<String>).value
          : '';

      final confirmValidators = [
        requiredValidator,
        (String confirm) =>
            confirm != passwordValue ? InputErrorEnum.passwordMismatch : null,
      ];

      final updatedInputs =
          Map<String, GenericInput<dynamic>>.from(state.currentStep.inputs)
            ..[RegistrationInputKeys.confirmPassword] =
                GenericInput<String>.dirty(
              value: confirmValue,
              validators: confirmValidators,
              uiType: UiTypeEnum.password,
            );

      emit(state.copyWith(
          currentStep: state.currentStep.copyWith(inputs: updatedInputs)));
    }
  }

  /// Attempts to submit the form, updating status based on validation result
  @override
  void submit() {
    if (!state.isAllValid) {
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure, erroneousSteps: [0, 1, 2, 3]));
      return;
    }

    emit(state.copyWith(erroneousSteps: []));
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    // Simulate form submission
    Future.delayed(Duration(seconds: 1), () {
      state.toJson().debug('map:');
      emit(state.copyWith(
          status: FormzSubmissionStatus.failure, erroneousSteps: [0, 2]));
    });
  }

  @override
  void reset() {
    emit(FacilityRegistrationFormzState.init());
  }
}
