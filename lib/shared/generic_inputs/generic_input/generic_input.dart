import 'package:flutter/foundation.dart';
import 'package:utils_package/utils_package.dart';
import 'package:waste_management/src/core/functions/get_multi_part_file_from_path.dart';
import 'package:formz_example/shared/enum/input_error_enum.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/mixins_behavior/async_to_json.dart';
import 'package:formz_example/shared/mixins_behavior/sync_to_json.dart';
import 'package:formz_example/shared/validators/validator_type.dart';
part 'generic_sync_input.dart';
part 'generic_async_input.dart';

sealed class GenericInput<T> extends FormzInput<T, InputErrorEnum> {
  final String id;
  final String? label;
  final String? placeHolder;
  final List<Validator<T>> validators;
  final String? toJsonKey;
  final String? fromJsonKey;
  final UiTypeEnum uiType;
  final bool isAlreadyTranslated;
  final T Function(Map<String, dynamic>)? valueFromJsonFunction;
  final Future<Map<String, dynamic>> Function(T)? valueToJsonFunction;
  final bool isDisabled;

  const GenericInput.pure({
    this.id = '',
    this.label,
    required this.validators,
    required T value,
    required this.uiType,
    this.toJsonKey,
    this.placeHolder,
    this.fromJsonKey,
    this.valueFromJsonFunction,
    required this.isDisabled,
    this.isAlreadyTranslated = true,
    required this.valueToJsonFunction,
  }) : // _customToJson = customToJson,
        super.pure(value);
  // Map<String, dynamic> get toJson {
  //   return _customToJson?.call() ?? _toJsonBaseMethod();
  // }

  /// Creates a pure (unmodified) instance of [GenericInput]
  ///
  /// [validators] - List of validator functions to apply
  /// [value] - Initial value of the input

  // Map<String, dynamic> _toJsonBaseMethod() {
  //   return {
  //     (toJsonKey ?? value.hashCode.toString()): value,
  //   };
  // }

  /// Creates a dirty (modified) instance of [GenericInput]
  ///
  /// [validators] - List of validator functions to apply
  /// [value] - Current value of the input
  const GenericInput.dirty({
    this.id = '',
    this.label,
    required this.validators,
    required T value,
    required this.uiType,
    this.toJsonKey,
    this.fromJsonKey,
    this.placeHolder,
    this.valueFromJsonFunction,
    required this.valueToJsonFunction,
    this.isAlreadyTranslated = true,
    required this.isDisabled,
  }) : //_customToJson = customToJson,
        super.dirty(value);

  @override
  InputErrorEnum? validator(T value) {
    for (final validate in validators) {
      final error = validate(value);
      if (error != null) return error;
    }
    return null;
  }

  bool get isRequired {
    return validators.any((v) {
      return v.toString().toLowerCase().contains('require');
    });
  }

  bool get isOptional => !isRequired;

  /// Creates a copy of this [GenericInput] with the given fields replaced with the new values
  GenericInput<T> copyWith({
    String? id,
    ValueGetter<String?>? label,
    ValueGetter<String?>? placeHolder,
    List<Validator<T>>? validators,
    ValueGetter<T>? value,
    String? toJsonKey,
    String? fromJsonKey,
    bool? isDisabled,
    UiTypeEnum? uiType,
    bool? isAlreadyTranslated,
    ValueGetter<T Function(Map<String, dynamic>)?>? valueFromJsonFunction,
  });

  T valueFromJson(Map<String, dynamic> json) {
    if (valueFromJsonFunction != null) {
      return valueFromJsonFunction!(json);
    }
    if (fromJsonKey != null && json.containsKey(fromJsonKey!)) {
      return json[fromJsonKey!] as T;
    } else {
      return value;
    }
  }

  valueToJson(T value);
  //  async {
  //   if (valueToJsonFunction != null) {
  //     return await valueToJsonFunction!(value);
  //   }
  //   if (toJsonKey != null) {
  //     return {toJsonKey!: value};
  //   } else {
  //     return {value.hashCode.toString(): value};
  //   }
  // }

  int get customHash {
    return Object.hash(
      id,
      label,
      isDisabled,
      validators,
      placeHolder,
      toJsonKey,
      fromJsonKey,
      valueFromJsonFunction,
      isAlreadyTranslated,
      uiType,
    );
  }
}
