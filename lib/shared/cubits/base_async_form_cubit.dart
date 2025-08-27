part of 'base_form_cubit.dart';

abstract class AsyncFormCubitBase<S extends FormzAsyncBaseState>
    extends FormCubitBase<S> {
  AsyncFormCubitBase(super.initState);
  @override
  void updateInput<T>(String fieldKey, T value) {
    final inputs =
        state.currentStep.inputs as Map<String, GenericAsyncInput<dynamic>>?;
    final existingInput = inputs?[fieldKey];
    if (existingInput == null) {
      return;
    }

    final input = existingInput.copyWith(value: () => value);
    final updatedInputs =
        Map<String, GenericAsyncInput<dynamic>>.from(state.currentStep.inputs)
          ..[fieldKey] = input;

    emit(state.copyWith(
        currentStep: state.currentStep.copyWith(
            inputs: updatedInputs,
            status: state.currentStep.status == FormzSubmissionStatus.failure
                ? FormzSubmissionStatus.initial
                : null)) as S);
  }

  @override
  void nextStep() {
    emit(state.copyWith(currentStepIndex: state.currentStepIndex + 1) as S);
  }

  void toStep(int stepIndex) {
    emit(state.copyWith(currentStepIndex: stepIndex) as S);
  }

  @override
  void previousStep() {
    emit(state.copyWith(currentStepIndex: state.currentStepIndex - 1) as S);
  }

  @override
  void submitForm();
  @override
  void reset();
}
