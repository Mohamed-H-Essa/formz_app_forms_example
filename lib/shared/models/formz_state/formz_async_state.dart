part of 'formz_state.dart';

abstract class FormzAsyncBaseState<StepStateB extends FormzAsyncStepBaseState>
    extends FormzBaseState<StepStateB> with AsyncToJson {
  const FormzAsyncBaseState({
    required super.steps,
    required super.currentStepIndex,
    required super.status,
    required super.erroneousSteps,
  })  : assert(steps.length > 0, 'steps cannot be empty'),
        assert(currentStepIndex >= 0 && currentStepIndex < steps.length,
            'currentStepIndex out of bounds');

  @override
  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> result = {};
    for (final step in steps) {
      final stepJson = await step.toJson();
      result.addAll(stepJson);
    }
    return Future.value(result);
  }
}
