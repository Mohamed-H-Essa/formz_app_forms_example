part of 'step_state.dart';

abstract class FormzAsyncStepBaseState
    extends FormzStepBaseState<GenericAsyncInput> with AsyncToJson {
  const FormzAsyncStepBaseState({
    required super.stepId,
    required super.stepTitle,
    required super.inputs,
    super.status = FormzSubmissionStatus.initial,
    super.apiJsonValidator,
    super.errorMessage,
  });

  @override
  FormzAsyncStepBaseState copyWith({
    String? stepId,
    String? stepTitle,
    Map<String, GenericAsyncInput>? inputs,
    FormzSubmissionStatus? status,
    ValueGetter<Map<String, dynamic> Function()?>? apiJsonValidator,
    String? errorMessage,
  });

  @override
  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> result = {};
    for (final entry in inputs.entries) {
      final inputJson = await entry.value.toJson();
      result.addAll(inputJson);
    }
    return result;
  }

  @override
  inputsFromJson(Map<String, dynamic> json) {
    final Map<String, GenericAsyncInput> inputs = this.inputs;
    return inputs.map(
      (k, v) => MapEntry(
        k,
        v.copyWith(value: () => v.valueFromJson(json)),
      ),
    );
  }
}
