import 'package:formz/formz.dart';

/// Function type for validators that take a value and return an error message
typedef Validator<T> = String? Function(T value);

/// A generic input class that can handle various input types and multiple validators
class GenericInput<T> extends FormzInput<T, String> {
  final List<Validator<T>> validators;

  /// Creates a pure (unchanged) input with validators
  const GenericInput.pure({required this.validators, required T value})
      : super.pure(value);

  /// Creates a dirty (changed) input with validators
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
