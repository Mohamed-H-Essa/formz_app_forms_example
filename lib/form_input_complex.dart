// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:equatable/equatable.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';
// import 'package:formz_example/debug_extension.dart';
// import 'package:formz_example/facility_registration/cubit/facility_registration_state.dart';
// import 'package:formz_example/shared/enum/form_field_enum.dart';
// import 'package:formz_example/shared/validators/validators.dart';

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
// ///
// ///
// class FormzState extends Equatable {
//   final List<FormzStepState> steps;
//   final int currentStepIndex;
//   final FormzSubmissionStatus status;
//   final List<int> erroneousSteps;
//   const FormzState({
//     required this.steps,
//     // required this.step2,
//     // required this.step3,
//     required this.currentStepIndex,
//     required this.status,
//     required this.erroneousSteps,
//   });

//   factory FormzState.init() {
//     return FormzState(
//       steps: [
//         FormzStepState(stepId: 'step1', inputs: _initStep1Inputs()),
//         FormzStepState(stepId: 'step2', inputs: _initStep2Inputs()),
//         FormzStepState(stepId: 'step3', inputs: _initStep3Inputs()),
//       ],
//       // step2: FormzStepState(stepId: 'step2', inputs: _initStep2Inputs()),
//       // step3: FormzStepState(stepId: 'step3', inputs: _initStep3Inputs()),
//       currentStepIndex: 1,
//       status: FormzSubmissionStatus.initial,
//       erroneousSteps: const [],
//     );
//   }

//   /// Initialize Step 1 (Personal Information) with predefined fields and validators
//   static Map<String, FormzInput> _initStep1Inputs() {
//     return {
//       // Basic form fields
//       // String.email: GenericInput<String>.pure(
//       //   value: '',
//       //   validators: [requiredValidator, emailValidator],
//       // ),
//       // String.password: GenericInput<String>.pure(
//       //   value: '',
//       //   validators: [
//       //     requiredValidator,
//       //     minLengthValidator(8),
//       //     hasNumberValidator,
//       //     hasSpecialCharValidator,
//       //   ],
//       // ),
//       // String.confirmPassword: GenericInput<String>.pure(
//       //   value: '',
//       //   validators: [requiredValidator, _confirmPasswordValidator],
//       // ),
//       // String.age: GenericInput<String>.pure(
//       //   value: '20',
//       //   validators: [
//       //     requiredValidator,
//       //     _ageValidator,
//       //   ],
//       // ),
//       // Complex form fields
//       String.firstName: GenericInput<String>.pure(
//         value: '',
//         validators: [requiredValidator],
//       ),
//       String.lastName: GenericInput<String>.pure(
//         value: '',
//         validators: [requiredValidator],
//       ),
//       String.dob: GenericInput<String>.pure(
//         value: '',
//         validators: [
//           requiredValidator,
//           _dobValidator,
//         ],
//       ),
//     };
//   }

//   /// Initialize Step 2 (Contact Details) with predefined fields and validators
//   static Map<String, FormzInput> _initStep2Inputs() {
//     return {
//       String.email: GenericInput<String>.pure(
//         value: '',
//         validators: [requiredValidator, emailValidator],
//       ),
//       String.phone: GenericInput<String>.pure(
//         value: '',
//         validators: [requiredValidator, phoneValidator],
//       ),
//       String.address: GenericInput<String>.pure(
//         value: '',
//         validators: [], // Optional field, no validators
//       ),
//     };
//   }

//   /// Initialize Step 3 (Preferences) with predefined fields and validators
//   static Map<String, FormzInput> _initStep3Inputs() {
//     return {
//       String.notificationChannel: GenericInput<String>.pure(
//         value: '',
//         validators: [requiredValidator],
//       ),
//       String.termsAccepted: GenericInput<bool>.pure(
//         value: false,
//         validators: [_termsValidator],
//       ),
//     };
//   }

//   /// Date of birth validator
//   static String? _dobValidator(String value) {
//     if (value.isEmpty) return null; // Let required validator handle this
//     final datePattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
//     if (!datePattern.hasMatch(value)) {
//       return 'Use format: DD/MM/YYYY';
//     }
//     return null;
//   }

//   /// Terms and conditions validator
//   static String? _termsValidator(bool value) {
//     return value != true ? 'You must accept the terms and conditions' : null;
//   }

//   /// Age validator
//   static String? _ageValidator(String value) {
//     if (value.isEmpty) return null; // Let required validator handle this
//     final age = int.tryParse(value);
//     if (age == null) return 'Please enter a valid number';
//     return numberRangeValidator(age, 18, 120);
//   }

//   /// Confirm password validator (dynamic validation handled in updateInput)
//   static String? _confirmPasswordValidator(String value) {
//     // This will be updated dynamically when password changes
//     return null;
//   }

//   FormzStepState get currentStep {
//     return steps[currentStepIndex - 1];
//     // switch (currentStepIndex) {
//     //   case 1:
//     //     return step1;
//     //   case 2:
//     //     return step2;
//     //   case 3:
//     //     return step3;
//     //   default:
//     //     return step1;
//     // }
//   }

//   bool get isAllValid {
//     // return true;
//     return !steps.any((step) => step.isNotValid
//       ..debug('validator step No. ${step.stepId} is not valid: '));
//     // if (step1.isValid && step2.isValid && step3.isValid) {
//     //   return true;
//     // } else {
//     //   return false;
//     // }
//   }

//   bool isPersonalInfoValid(FormzState state) {
//     return state.steps[0].inputs[String.firstName]?.isValid == true &&
//         state.steps[0].inputs[String.lastName]?.isValid == true &&
//         state.steps[0].inputs[String.dob]?.isValid == true;
//   }

//   bool isContactDetailsValid(FormzState state) {
//     return state.steps[1].inputs[String.email]?.isValid == true &&
//         state.steps[1].inputs[String.phone]?.isValid == true;
//   }

//   bool isPreferencesValid(FormzState state) {
//     'isPreferencesValid : '.debug();
//     return (state.steps[2].inputs[String.notificationChannel]?.isValid ==
//         true)
//       ..debug('isPreferencesValid : ');
//   }

//   @override
//   List<Object?> get props => [steps, currentStepIndex, status, erroneousSteps];
//   FormzState copyWith({
//     FormzStepState? currentStep,
//     List<FormzStepState>? steps,
//     int? currentStepIndex,
//     FormzSubmissionStatus? status,
//     List<int>? erroneousSteps,
//   }) {
//     return FormzState(
//       steps: steps ??
//           (currentStep == null
//               ? this.steps
//               : (List<FormzStepState>.from(this.steps)
//                 ..[this.currentStepIndex - 1] = currentStep)),
//       currentStepIndex: currentStepIndex ?? this.currentStepIndex,
//       status: status ?? this.status,
//       erroneousSteps: erroneousSteps ?? this.erroneousSteps,
//     );
//   }

//   bool isErroneous(int index) {
//     return erroneousSteps.contains(index);
//   }

//   @override
//   String toString() {
//     return 'FormzState{steps=$steps, currentStepIndex=$currentStepIndex, status=$status}';
//   }
// }

// // class FormzStepState extends Equatable {
// // class FormzStepState extends Equatable {
// //   final String stepId;

// //   /// Map of form inputs, keyed by String enum values
// //   final Map<String, FormzInput> inputs;
// //   final String? errorMessage;

// //   /// Optional function to convert form inputs to a JSON structure for API validation
// //   /// Returns a Map that can be sent to the API for server-side validation
// //   /// Can be null if server validation is not needed for this step
// //   final Map<String, dynamic> Function()? apiJsonValidator;

// //   /// Current submission status of the form
// //   final FormzSubmissionStatus status;

// //   /// Creates a new [FormzStepState] instance
// //   ///
// //   /// [inputs] - Map of form input fields
// //   /// [status] - Form submission status, defaults to initial
// //   const FormzStepState({
// //     required this.stepId,
// //     required this.inputs,
// //     this.status = FormzSubmissionStatus.initial,
// //     this.apiJsonValidator,
// //     this.errorMessage,
// //   });

// //   /// Whether all inputs in the form are valid
// //   bool get isValid => !isNotValid;
// //   // errorMessage != null
// //   //     ? true
// //   //     : inputs.values
// //   //         .any((t) => t.isValid) //Formz.validate(inputs.values.toList())
// //   //   ..debug('Formz.validate(inputs.values.toList()) ');
// //   bool get isNotValid => errorMessage != null
// //       ? true
// //       : (inputs.values..debug('inputs.values $stepId '))
// //           .any((t) => t.isNotValid);

// //   /// Creates a copy of this [FormzStepState] with the given fields replaced
// //   ///
// //   /// [inputs] - New inputs map (optional)
// //   /// [status] - New submission status (optional)
// //   FormzStepState copyWith({
// //     String? stepId,
// //     Map<String, FormzInput>? inputs,
// //     FormzSubmissionStatus? status,
// //     ValueGetter<Map<String, dynamic> Function()?>? apiJsonValidator,
// //     ValueGetter<String?>? errorMessage,
// //   }) {
// //     return FormzStepState(
// //       stepId: stepId ?? this.stepId,
// //       inputs: inputs ?? this.inputs,
// //       status: status ?? this.status,
// //       apiJsonValidator:
// //           apiJsonValidator != null ? apiJsonValidator() : this.apiJsonValidator,
// //       errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
// //     );
// //   }

// //   @override
// //   String toString() {
// //     return 'FormzStepState{stepId=$stepId, inputs=$inputs, status=$status}';
// //   }

// //   @override
// //   List<Object?> get props => [inputs, status, stepId, apiJsonValidator];
// // }

// /// Cubit for managing form state and operations
// class FormCubit extends Cubit<FormzState> {
//   /// Creates a new [FormCubit] with an empty inputs map
//   FormCubit() : super(FormzState.init());

//   /// Updates a form input with a new value using the predefined validators
//   ///
//   /// [field] - The String enum value identifying the form field
//   /// [value] - The new value for the field
//   void updateInput<T>(String field, T value) {
//     final existingInput = state.currentStep.inputs[field];
//     if (existingInput == null) return; // Field doesn't exist in current step

//     final validators = (existingInput as GenericInput<T>).validators;
//     final input = GenericInput<T>.dirty(value: value, validators: validators);

//     final updatedInputs =
//         Map<String, FormzInput>.from(state.currentStep.inputs)
//           ..[field] = input;

//     // Special handling for password field - update confirm password validation
//     if (field == String.password) {
//       final confirmPasswordInput =
//           state.currentStep.inputs[String.confirmPassword];
//       if (confirmPasswordInput != null) {
//         final confirmValue =
//             (confirmPasswordInput as GenericInput<String>).value;
//         final confirmValidators = [
//           requiredValidator,
//           (String confirm) =>
//               confirm != value ? 'Passwords do not match' : null,
//         ];
//         updatedInputs[String.confirmPassword] =
//             GenericInput<String>.dirty(
//           value: confirmValue,
//           validators: confirmValidators,
//         );
//       }
//     }

//     emit(state.copyWith(
//         currentStep: state.currentStep.copyWith(inputs: updatedInputs)));
//   }

//   void nextStep() {
//     emit(state.copyWith(currentStepIndex: state.currentStepIndex + 1));
//   }

//   void previousStep() {
//     emit(state.copyWith(currentStepIndex: state.currentStepIndex - 1));
//   }

//   /// Attempts to submit the form, updating status based on validation result
//   void submit() {
//     if (!state.isAllValid) {
//       emit(state.copyWith(
//           status: FormzSubmissionStatus.failure, erroneousSteps: [0, 1, 2]));
//       return;
//     }

//     emit(state.copyWith(erroneousSteps: []));
//     emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

//     // Simulate form submission
//     Future.delayed(Duration(seconds: 1), () {
//       emit(state.copyWith(
//           status: FormzSubmissionStatus.failure, erroneousSteps: [1, 2]));
//     });
//   }

//   /// Reset the form to its initial state
//   void reset() {
//     emit(FormzState.init());
//   }
// }
