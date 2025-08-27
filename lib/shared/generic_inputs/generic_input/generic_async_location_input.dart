import 'package:flutter/material.dart';
import 'package:waste_management/features/map/domain/entities/location_data.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/validators/validator_type.dart';

class GenericAsyncLocationInput extends GenericAsyncInput<LocationData> {
  const GenericAsyncLocationInput.pure({
    required super.validators,
    required super.value,
    required super.uiType,
    super.id = '',
    super.isDisabled = false,
    super.label,
    super.toJsonKey,
    super.placeHolder,
    super.fromJsonKey,
    super.isAlreadyTranslated = true,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
  }) : super.pure();

  @override
  LocationData jsonToValue(Map<String, dynamic> json) {
    if (fromJsonKey != null && json.containsKey(fromJsonKey!)) {
      return json[fromJsonKey!] as LocationData;
    } else {
      throw Exception('No fromJson or fromJsonKey provided for $LocationData');
    }
  }

  const GenericAsyncLocationInput.dirty({
    super.id = '',
    super.label,
    required super.validators,
    required super.value,
    required super.uiType,
    super.toJsonKey,
    super.fromJsonKey,
    super.placeHolder,
    super.isAlreadyTranslated = true,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
    super.isDisabled = false,
  }) : super.dirty();

  @override
  GenericAsyncLocationInput copyWith({
    String? id,
    ValueGetter<String?>? label,
    ValueGetter<String?>? placeHolder,
    List<Validator<LocationData>>? validators,
    ValueGetter<dynamic>? value,
    String? toJsonKey,
    String? fromJsonKey,
    UiTypeEnum? uiType,
    bool? isAlreadyTranslated,
    ValueGetter<LocationData Function(Map<String, dynamic>)?>?
        valueFromJsonFunction,
    ValueGetter<Future<Map<String, dynamic>> Function(LocationData)?>?
        valueToJsonFunction,
    bool? isDisabled,
  }) {
    if (isPure && value == null || (value?.call()) == null) {
      return GenericAsyncLocationInput.pure(
        id: id ?? this.id,
        validators: validators ?? this.validators,
        label: label != null ? label() : this.label,
        uiType: uiType ?? this.uiType,
        value: value != null ? value() as LocationData : this.value,
        placeHolder:
            placeHolder != null ? placeHolder.call() : this.placeHolder,
        toJsonKey: toJsonKey ?? this.toJsonKey,
        fromJsonKey: fromJsonKey ?? this.fromJsonKey,
        valueToJsonFunction: valueToJsonFunction != null
            ? valueToJsonFunction()
            : this.valueToJsonFunction,
        valueFromJsonFunction: valueFromJsonFunction != null
            ? valueFromJsonFunction()
            : this.valueFromJsonFunction,
        isDisabled: isDisabled ?? this.isDisabled,
        isAlreadyTranslated: isAlreadyTranslated ?? this.isAlreadyTranslated,
      );
    } else {
      return GenericAsyncLocationInput.dirty(
        id: id ?? this.id,
        validators: validators ?? this.validators,
        label: label != null ? label() : this.label,
        uiType: uiType ?? this.uiType,
        value: value != null ? value() : this.value,
        placeHolder:
            placeHolder != null ? placeHolder.call() : this.placeHolder,
        toJsonKey: toJsonKey ?? this.toJsonKey,
        fromJsonKey: fromJsonKey ?? this.fromJsonKey,
        valueToJsonFunction: valueToJsonFunction != null
            ? valueToJsonFunction()
            : this.valueToJsonFunction,
        valueFromJsonFunction: valueFromJsonFunction != null
            ? valueFromJsonFunction()
            : this.valueFromJsonFunction,
        isDisabled: isDisabled ?? this.isDisabled,
        isAlreadyTranslated: isAlreadyTranslated ?? this.isAlreadyTranslated,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> toJson() async {
    return {
      'longitude': value.lng,
      'latitude': value.lat,
    };
  }
}
