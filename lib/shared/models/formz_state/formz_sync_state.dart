part of 'formz_state.dart';

abstract class FormzSyncBaseState<StepStateB extends FormzStepBaseState>
    extends FormzBaseState<StepStateB> with SyncToJson {
  const FormzSyncBaseState({
    required super.steps,
    required super.currentStepIndex,
    required super.status,
    required super.erroneousSteps,
  });
}
