🧱 Architecture Overview
To accommodate various input types and validators without creating a new class for each, we'll implement a generic GenericInput class. This class will accept a list of validators, allowing for flexible and reusable validation logic.

1. Generic Input Class
dart
Copy
Edit
import 'package:formz/formz.dart';

typedef Validator<T> = String? Function(T value);

class GenericInput<T> extends FormzInput<T, String> {
  final List<Validator<T>> validators;

  const GenericInput.pure({required this.validators, required T value})
      : super.pure(value);

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
This class allows you to define any number of validators for different input types, promoting code reuse and scalability.

2. Form State
dart
Copy
Edit
import 'package:formz/formz.dart';

class FormState {
  final Map<String, FormzInput> inputs;
  final FormzSubmissionStatus status;

  FormState({
    required this.inputs,
    this.status = FormzSubmissionStatus.initial,
  });

  bool get isValid => Formz.validate(inputs.values.toList());

  FormState copyWith({
    Map<String, FormzInput>? inputs,
    FormzSubmissionStatus? status,
  }) {
    return FormState(
      inputs: inputs ?? this.inputs,
      status: status ?? this.status,
    );
  }
}
This state class holds a map of input fields, allowing dynamic addition and validation of form fields.

3. Form Cubit
dart
Copy
Edit
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class FormCubit extends Cubit<FormState> {
  FormCubit() : super(FormState(inputs: {}));

  void updateInput<T>(String fieldKey, T value, List<Validator<T>> validators) {
    final input = GenericInput<T>.dirty(value: value, validators: validators);
    final updatedInputs = Map<String, FormzInput>.from(state.inputs)
      ..[fieldKey] = input;
    emit(state.copyWith(inputs: updatedInputs));
  }

  void submit() {
    if (!state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    // Simulate form submission
    Future.delayed(Duration(seconds: 1), () {
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    });
  }
}
The FormCubit manages form state, handling input updates and submission logic.

🧪 Validators
Define reusable validators as functions:

dart
Copy
Edit
String? requiredValidator(String value) =>
    value.isEmpty ? 'This field is required' : null;

String? emailValidator(String value) =>
    RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value) ? null : 'Invalid email';

String? minLengthValidator(int minLength) {
  return (String value) =>
      value.length >= minLength ? null : 'Minimum length is $minLength';
}
These validators can be combined and assigned to different fields as needed.

🧩 UI Integration
Here's how you might integrate this setup into your Flutter UI:

dart
Copy
Edit
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DynamicForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormCubit(),
      child: BlocBuilder<FormCubit, FormState>(
        builder: (context, state) {
          final cubit = context.read<FormCubit>();

          return Column(
            children: [
              TextField(
                onChanged: (value) => cubit.updateInput<String>(
                  'email',
                  value,
                  [requiredValidator, emailValidator],
                ),
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: state.inputs['email']?.displayError,
                ),
              ),
              TextField(
                onChanged: (value) => cubit.updateInput<String>(
                  'password',
                  value,
                  [requiredValidator, minLengthValidator(8)],
                ),
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: state.inputs['password']?.displayError,
                ),
              ),
              ElevatedButton(
                onPressed: () => cubit.submit(),
                child: Text('Submit'),
              ),
              if (state.status == FormzSubmissionStatus.inProgress)
                CircularProgressIndicator(),
              if (state.status == FormzSubmissionStatus.success)
                Text('Form submitted successfully!'),
              if (state.status == FormzSubmissionStatus.failure)
                Text('Form submission failed. Please check your inputs.'),
            ],
          );
        },
      ),
    );
  }
}
This UI dynamically reflects the form state managed by the FormCubit, displaying validation errors and submission status.
Dart packages

✅ Benefits of This Approach
Scalability: Easily add new fields with different validation requirements without creating new classes.

Reusability: Validators are defined once and can be reused across multiple fields.

Maintainability: Centralized form state management simplifies debugging and testing.

Flexibility: Supports dynamic forms where fields can be added or removed at runtime.

By adopting this architecture, your team can efficiently handle complex forms in your Flutter application, ensuring a clean and maintainable codebase.