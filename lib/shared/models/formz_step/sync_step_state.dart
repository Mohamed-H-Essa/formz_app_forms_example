part of 'step_state.dart';

abstract class FormzSyncStepBaseState
    extends FormzStepBaseState<GenericSyncInput> with SyncToJson {
  const FormzSyncStepBaseState({
    required super.stepId,
    required super.stepTitle,
    required super.inputs,
    super.status = FormzSubmissionStatus.initial,
    super.apiJsonValidator,
    super.errorMessage,
  });

  @override
  FormzStepBaseState copyWith(
      {String? stepId,
      String? stepTitle,
      Map<String, GenericSyncInput>? inputs,
      FormzSubmissionStatus? status,
      ValueGetter<Map<String, dynamic> Function()?>? apiJsonValidator,
      String? errorMessage});

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    for (final entry in inputs.entries) {
      final inputJson = entry.value.toJson();
      result.addAll(inputJson);
    }
    return result;
  }
}
