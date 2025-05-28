import 'package:formz/formz.dart';
import 'package:formz_example/debug_extension.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/validators/validator_type.dart';

class GenericInput<T> extends FormzInput<T, String> {
  /// List of validator functions to apply to the input value
  final String id;
  final List<Validator<T>> validators;
  final String? toJsonKey;
  final String? fromJsonKey;
  final Map<String, dynamic> Function()? _customToJson;
  final GenericInput<T> Function(Map m)? fromJson;
  final UiTypeEnum uiType;

  Map<String, dynamic> get toJson {
    // if (_customToJson == null) {
    //   return toJsonBaseMethod();
    // } else {
    //   return _customToJson!();
    // }
    return _customToJson?.call() ?? _toJsonBaseMethod();
  }

  /// Creates a pure (unmodified) instance of [GenericInput]
  ///
  /// [validators] - List of validator functions to apply
  /// [value] - Initial value of the input
  const GenericInput.pure({
    this.id = '',
    required this.validators,
    required T value,
    required this.uiType,
    this.toJsonKey,
    this.fromJsonKey,
    this.fromJson,
    Map<String, dynamic> Function()? customToJson,
  })  : _customToJson = customToJson,
        super.pure(value);

  Map<String, dynamic> _toJsonBaseMethod() {
    return {
      (toJsonKey ?? value.hashCode.toString()): value,
    };
  }

  /// Creates a dirty (modified) instance of [GenericInput]
  ///
  /// [validators] - List of validator functions to apply
  /// [value] - Current value of the input
  const GenericInput.dirty({
    this.id = '',
    required this.validators,
    required T value,
    required this.uiType,
    this.toJsonKey,
    this.fromJsonKey,
    this.fromJson,
    Map<String, dynamic> Function()? customToJson,
  })  : _customToJson = customToJson,
        super.dirty(value);

  @override
  String? validator(T value) {
    'String? validator'.debug();
    for (final validate in validators) {
      final error = validate(value);
      if (error != null) return error;
    }
    return null;
  }

  /// Creates a copy of this [GenericInput] with the given fields replaced with the new values
  GenericInput<T> copyWith({
    String? id,
    List<Validator<T>>? validators,
    T? value,
    String? toJsonKey,
    String? fromJsonKey,
    UiTypeEnum? uiType,
  }) {
    if (isPure && value == null) {
      return GenericInput.pure(
        id: id ?? this.id,
        validators: validators ?? this.validators,
        uiType: uiType ?? this.uiType,
        value: value ?? this.value,
        toJsonKey: toJsonKey ?? this.toJsonKey,
        fromJsonKey: fromJsonKey ?? this.fromJsonKey,
      );
    } else {
      return GenericInput.dirty(
        id: id ?? this.id,
        validators: validators ?? this.validators,
        uiType: uiType ?? this.uiType,
        value: value ?? this.value,
        toJsonKey: toJsonKey ?? this.toJsonKey,
        fromJsonKey: fromJsonKey ?? this.fromJsonKey,
      );
    }
  }
}
