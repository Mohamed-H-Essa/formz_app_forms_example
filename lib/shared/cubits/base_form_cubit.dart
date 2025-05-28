import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/debug_extension.dart';
import 'package:formz_example/shared/enum/form_field_enum.dart';
import 'package:formz_example/shared/generic_inputs/generic_input.dart';
import 'package:formz_example/shared/models/formz_state.dart';

abstract class FormCubitBase<S extends FormzBaseState> extends Cubit<S> {
  FormCubitBase(S initState) : super(initState);
  void updateInput<T>(String fieldKey, T value) {
    fieldKey.debug('updateInput<T>');
    var existingInput = state.currentStep.inputs[fieldKey];
    if (existingInput == null) {
      return;
    }

    existingInput = (existingInput as GenericInput<T>);
    final validators = existingInput.validators;
    final input = existingInput.copyWith(value: value);
    GenericInput<T>.dirty(
        value: value, validators: validators, uiType: existingInput.uiType);
    //todo: use copyWith
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

  void submit();
  void reset();
}
