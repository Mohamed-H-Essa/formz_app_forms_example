import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';
part 'base_async_form_cubit.dart';

sealed class FormCubitBase<S extends FormzBaseState> extends Cubit<S> {
  FormCubitBase(super.initState)
      : assert(initState.steps.isNotEmpty, 'Steps cannot be empty');
  void updateInput<T>(String fieldKey, T value) {
    var existingInput = state.currentStep.inputs[fieldKey];
    if (existingInput == null) {
      return;
    }

    existingInput = (existingInput as GenericInput<T>);
    final validators = existingInput.validators;
    final input = existingInput.copyWith(value: () => value);
    GenericSyncInput<T>.dirty(value: value, validators: validators);

    final updatedInputs =
        Map<String, GenericInput<dynamic>>.from(state.currentStep.inputs)
          ..[fieldKey] = input;
    emit(state.copyWith(
        currentStep: state.currentStep.copyWith(inputs: updatedInputs)) as S);
  }

  void nextStep() {
    emit(state.copyWith(currentStepIndex: state.currentStepIndex + 1) as S);
  }

  void previousStep() {
    emit(state.copyWith(currentStepIndex: state.currentStepIndex - 1) as S);
  }

  void submitForm();
  void reset();
}
