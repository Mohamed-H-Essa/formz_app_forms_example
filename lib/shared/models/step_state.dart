import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/shared/enum/form_field_enum.dart';
import 'package:formz_example/shared/generic_inputs/generic_input.dart';

abstract class FormzStepBaseState extends Equatable {
  final String stepId;

  /// Map of form inputs, keyed by FormFieldEnum enum values
  final Map<FormFieldEnum, GenericInput> inputs;
  final String? errorMessage;

  /// Optional function to convert form inputs to a JSON structure for API validation
  /// Returns a Map that can be sent to the API for server-side validation
  /// Can be null if server validation is not needed for this step
  final Map<String, dynamic> Function()? apiJsonValidator;

  /// Current submission status of the form
  final FormzSubmissionStatus status;

  /// Creates a new [FormzStepState] instance
  ///
  /// [inputs] - Map of form input fields
  /// [status] - Form submission status, defaults to initial
  const FormzStepBaseState({
    required this.stepId,
    required this.inputs,
    this.status = FormzSubmissionStatus.initial,
    this.apiJsonValidator,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    for (final entry in inputs.entries) {
      final inputJson = entry.value.toJson;
      result.addAll(inputJson);
    }
    return result;
  }

  /// Whether all inputs in the form are valid
  bool get isValid => !isNotValid;
  // errorMessage != null
  //     ? true
  //     : inputs.values
  //         .any((t) => t.isValid) //Formz.validate(inputs.values.toList())
  //   ..debug('Formz.validate(inputs.values.toList()) ');
  bool get isNotValid =>
      errorMessage != null ? true : (inputs.values).any((t) => t.isNotValid);

  /// Creates a copy of this [FormzStepState] with the given fields replaced
  ///
  /// All parameters are optional - only provide the fields you want to change
  /// [stepId] - New step ID (optional)
  /// [inputs] - New inputs map (optional)
  /// [status] - New submission status (optional)
  /// [apiJsonValidator] - New API validator function (optional)
  /// [errorMessage] - New error message (optional)
  FormzStepBaseState copyWith({
    String? stepId,
    Map<FormFieldEnum, GenericInput>? inputs,
    FormzSubmissionStatus? status,
    ValueGetter<Map<String, dynamic> Function()?>? apiJsonValidator,
    String? errorMessage,
  });

  @override
  String toString() {
    return 'FormzStepState{stepId=$stepId, inputs=$inputs, status=$status}';
  }

  @override
  List<Object?> get props => [inputs, status, stepId, apiJsonValidator];
}
