// import 'package:formz/formz.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'form_field.dart';

// /// Type definition for a validator function that takes a value of type T
// /// and returns either an error message (String) or null if validation passes.
// typedef Validator<T> = String? Function(T value);

// /// Generic input class that extends [FormzInput] for handling form inputs
// /// of any type with customizable validation.
// class GenericInput<T> extends FormzInput<T, String> {
//   /// List of validator functions to apply to the input value
//   final List<Validator<T>> validators;

//   /// Creates a pure (unmodified) instance of [GenericInput]
//   ///
//   /// [validators] - List of validator functions to apply
//   /// [value] - Initial value of the input
//   const GenericInput.pure({required this.validators, required T value})
//       : super.pure(value);

//   /// Creates a dirty (modified) instance of [GenericInput]
//   ///
//   /// [validators] - List of validator functions to apply
//   /// [value] - Current value of the input
//   const GenericInput.dirty({required this.validators, required T value})
//       : super.dirty(value);

//   @override
//   String? validator(T value) {
//     for (final validate in validators) {
//       final error = validate(value);
//       if (error != null) return error;
//     }
//     return null;
//   }
// }

// /// Represents the state of a form, including all form inputs and submission status
// class FormzState extends Equatable {
//   /// Map of form inputs, keyed by FormFieldEnum enum values
//   final Map<FormFieldEnum, FormzInput> inputs;

//   /// Current submission status of the form
//   final FormzSubmissionStatus status;

//   /// Creates a new [FormzState] instance
//   ///
//   /// [inputs] - Map of form input fields
//   /// [status] - Form submission status, defaults to initial
//   FormzState({
//     required this.inputs,
//     this.status = FormzSubmissionStatus.initial,
//   });

//   /// Whether all inputs in the form are valid
//   bool get isValid => Formz.validate(inputs.values.toList());

//   /// Creates a copy of this [FormzState] with the given fields replaced
//   ///
//   /// [inputs] - New inputs map (optional)
//   /// [status] - New submission status (optional)
//   FormzState copyWith({
//     Map<FormFieldEnum, FormzInput>? inputs,
//     FormzSubmissionStatus? status,
//   }) {
//     return FormzState(
//       inputs: inputs ?? this.inputs,
//       status: status ?? this.status,
//     );
//   }

//   @override
//   List<Object?> get props => [inputs, status];
// }

// /// Cubit for managing form state and operations
// class FormCubit extends Cubit<FormzState> {
//   /// Creates a new [FormCubit] with an empty inputs map
//   FormCubit() : super(FormzState(inputs: {}));

//   /// Updates a form input with a new value and associated validators
//   ///
//   /// [field] - The FormFieldEnum enum value identifying the form field
//   /// [value] - The new value for the field
//   /// [validators] - List of validator functions to apply
//   void updateInput<T>(
//       FormFieldEnum field, T value, List<Validator<T>> validators) {
//     final input = GenericInput<T>.dirty(value: value, validators: validators);
//     final updatedInputs = Map<FormFieldEnum, FormzInput>.from(state.inputs)
//       ..[field] = input;
//     emit(state.copyWith(inputs: updatedInputs));
//   }

//   /// Attempts to submit the form, updating status based on validation result
//   void submit() {
//     if (!state.isValid) {
//       emit(state.copyWith(status: FormzSubmissionStatus.failure));
//       return;
//     }

//     emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

//     // Simulate form submission
//     Future.delayed(Duration(seconds: 1), () {
//       emit(state.copyWith(status: FormzSubmissionStatus.success));
//     });
//   }

//   /// Reset the form to its initial state
//   void reset() {
//     emit(FormzState(inputs: {}));
//   }
// }
