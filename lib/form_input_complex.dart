// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/debug_extension.dart';

import 'form_field.dart';

/// Type definition for a validator function that takes a value of type T
/// and returns either an error message (String) or null if validation passes.
typedef Validator<T> = String? Function(T value);

/// Generic input class that extends [FormzInput] for handling form inputs
/// of any type with customizable validation.
class GenericInput<T> extends FormzInput<T, String> {
  /// List of validator functions to apply to the input value
  final List<Validator<T>> validators;

  /// Creates a pure (unmodified) instance of [GenericInput]
  ///
  /// [validators] - List of validator functions to apply
  /// [value] - Initial value of the input
  const GenericInput.pure({required this.validators, required T value})
      : super.pure(value);

  /// Creates a dirty (modified) instance of [GenericInput]
  ///
  /// [validators] - List of validator functions to apply
  /// [value] - Current value of the input
  const GenericInput.dirty({required this.validators, required T value})
      : super.dirty(value);

  @override
  String? validator(T value) {
    for (final validate in validators) {
      final error = validate(value);
      if (error != null) return error;
    }
    return null;
  }
}

/// Represents the state of a form, including all form inputs and submission status
///
///
class FormzState extends Equatable {
  final FormzStepState step1;
  final FormzStepState step2;
  final FormzStepState step3;
  final int currentStepIndex;
  final FormzSubmissionStatus status;
  const FormzState({
    required this.step1,
    required this.step2,
    required this.step3,
    required this.currentStepIndex,
    required this.status,
  });

  factory FormzState.init() {
    return FormzState(
      step1: FormzStepState(inputs: const {}),
      step2: FormzStepState(inputs: const {}),
      step3: FormzStepState(inputs: const {}),
      currentStepIndex: 1,
      status: FormzSubmissionStatus.initial,
    );
  }

  FormzStepState get currentStep {
    switch (currentStepIndex) {
      case 1:
        return step1;
      case 2:
        return step2;
      case 3:
        return step3;
      default:
        return step1;
    }
  }

  bool get isAllValid {
    if (step1.isValid && step2.isValid && step3.isValid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  List<Object?> get props => [step1, step2, step3, currentStepIndex, status];
  FormzState copyWith({
    FormzStepState? currentStep,
    FormzStepState? step1,
    FormzStepState? step2,
    FormzStepState? step3,
    int? currentStepIndex,
    FormzSubmissionStatus? status,
  }) {
    return FormzState(
      // --> -> ------  => ==>  ==  <<->> <->
      step1: ((this.currentStepIndex) == 1 && (currentStep) != null)
          ? currentStep
          : step1 ?? this.step1,
      step2: (this.currentStepIndex == 2 && currentStep != null)
          ? currentStep
          : step2 ?? this.step2,
      step3: (this.currentStepIndex == 3 && currentStep != null)
          ? currentStep
          : step3 ?? this.step3,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'FormzState{step1=$step1, step2=$step2, step3=$step3, currentStepIndex=$currentStepIndex, status=$status}';
  }
}

// class FormzStepState extends Equatable {
class FormzStepState extends Equatable {
  /// Map of form inputs, keyed by FormFieldEnum enum values
  final Map<FormFieldEnum, FormzInput> inputs;

  /// Current submission status of the form
  final FormzSubmissionStatus status;

  /// Creates a new [FormzStepState] instance
  ///
  /// [inputs] - Map of form input fields
  /// [status] - Form submission status, defaults to initial
  FormzStepState({
    required this.inputs,
    this.status = FormzSubmissionStatus.initial,
  });

  /// Whether all inputs in the form are valid
  bool get isValid => Formz.validate(inputs.values.toList());

  /// Creates a copy of this [FormzStepState] with the given fields replaced
  ///
  /// [inputs] - New inputs map (optional)
  /// [status] - New submission status (optional)
  FormzStepState copyWith({
    Map<FormFieldEnum, FormzInput>? inputs,
    FormzSubmissionStatus? status,
  }) {
    return FormzStepState(
      inputs: inputs ?? this.inputs,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'FormzStepState{inputs=$inputs, status=$status}';
  }

  @override
  List<Object?> get props => [inputs, status];
}

/// Cubit for managing form state and operations
class FormCubit extends Cubit<FormzState> {
  /// Creates a new [FormCubit] with an empty inputs map
  FormCubit() : super(FormzState.init());

  /// Updates a form input with a new value and associated validators
  ///
  /// [field] - The FormFieldEnum enum value identifying the form field
  /// [value] - The new value for the field
  /// [validators] - List of validator functions to apply
  void updateInput<T>(
      FormFieldEnum field, T value, List<Validator<T>> validators) {
    final input = GenericInput<T>.dirty(value: value, validators: validators);
    final updatedInputs =
        Map<FormFieldEnum, FormzInput>.from(state.currentStep.inputs)
          ..[field] = input;
    emit(state.copyWith(
        currentStep: state.currentStep.copyWith(
            inputs: updatedInputs
              ..debug('Room999 : from update input copywith '))));
  }

  /// Attempts to submit the form, updating status based on validation result
  void submit() {
    if (!state.isAllValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    // Simulate form submission
    Future.delayed(Duration(seconds: 1), () {
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    });
  }

  /// Reset the form to its initial state
  void reset() {
    emit(FormzState.init());
  }
}
