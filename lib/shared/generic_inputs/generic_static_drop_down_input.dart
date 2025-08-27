import 'package:flutter/material.dart';
import 'package:waste_management/features/lookups/domain/entities/simple_lookup_item.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/validators/validator_type.dart';
import 'generic_input/generic_input.dart';

class GenericStaticDropDownInput<T> extends GenericAsyncInput<T> {
  final List<T> localItemsData;
  const GenericStaticDropDownInput.pure({
    required this.localItemsData,
    required super.validators,
    required super.value,
    super.isDisabled = false,
    super.placeHolder,
    super.label,
    super.id,
    super.toJsonKey,
    super.fromJsonKey,
    super.valueFromJsonFunction,
    super.isAlreadyTranslated = true,
    super.valueToJsonFunction,
  }) : super.pure(uiType: UiTypeEnum.staticDropdown);

  @override
  Future<Map<String, dynamic>> toJson() async {
    if (localItemsData.isNotEmpty && localItemsData.first is SimpleLookupItem) {
      return {
        toJsonKey ?? value.hashCode.toString(): (value as SimpleLookupItem).id,
      };
    } else {
      return super.toJson();
    }
  }

  @override
  GenericStaticDropDownInput<T> copyWith({
    String? id,
    ValueGetter<String?>? label,
    List<Validator<T>>? validators,
    ValueGetter<dynamic>? value,
    String? toJsonKey,
    String? fromJsonKey,
    ValueGetter<String?>? placeHolder,
    UiTypeEnum? uiType,
    List<T>? localItemsData,
    bool? isAlreadyTranslated,
    ValueGetter<T Function(Map<String, dynamic>)?>? valueFromJsonFunction,
    ValueGetter<Future<Map<String, dynamic>> Function(T)?>? valueToJsonFunction,
    bool? isDisabled,
  }) {
    return GenericStaticDropDownInput<T>.pure(
      validators: validators ?? this.validators,
      value: value != null ? value() as T : this.value,
      localItemsData: localItemsData ?? this.localItemsData,
      id: id ?? this.id,
      label: label != null ? label() : this.label,
      toJsonKey: toJsonKey ?? this.toJsonKey,
      fromJsonKey: fromJsonKey ?? this.fromJsonKey,
      isAlreadyTranslated: isAlreadyTranslated ?? this.isAlreadyTranslated,
      valueFromJsonFunction: valueFromJsonFunction != null
          ? valueFromJsonFunction()
          : this.valueFromJsonFunction,
      valueToJsonFunction: valueToJsonFunction != null
          ? valueToJsonFunction()
          : this.valueToJsonFunction,
      isDisabled: isDisabled ?? this.isDisabled,
    );
  }
}
