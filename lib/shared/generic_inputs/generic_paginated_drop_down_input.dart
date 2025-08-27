import 'package:flutter/material.dart';
import 'package:waste_management/features/lookups/domain/enums/lookup_dropdown_enum.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/validators/validator_type.dart';
import '../../../../features/lookups/domain/entities/simple_lookup_item.dart';
import 'generic_input/generic_input.dart';

class GenericPaginatedDropDownInput
    extends GenericAsyncInput<SimpleLookupItem?> {
  final LookupDropDownType lookupDropDownType;
  final String? superordinateKey;
  final String? customEndPointKey;
  final List<String>? subordinateKey;
  const GenericPaginatedDropDownInput.pure({
    required super.validators,
    required super.value,
    required this.lookupDropDownType,
    super.isDisabled = false,
    this.superordinateKey,
    this.subordinateKey,
    super.placeHolder,
    super.label,
    super.id,
    super.toJsonKey,
    super.fromJsonKey,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
    this.customEndPointKey,
    super.isAlreadyTranslated = true,
  }) : super.pure(uiType: UiTypeEnum.paginatedDropdown);
  const GenericPaginatedDropDownInput.dirty({
    required super.validators,
    required super.value,
    required this.lookupDropDownType,
    super.isDisabled = false,
    this.superordinateKey,
    this.subordinateKey,
    super.placeHolder,
    super.label,
    super.id,
    super.toJsonKey,
    super.fromJsonKey,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
    this.customEndPointKey,
    super.isAlreadyTranslated = true,
  }) : super.dirty(uiType: UiTypeEnum.paginatedDropdown);
  @override
  Future<Map<String, dynamic>> toJson() async {
    return {toJsonKey ?? value.hashCode.toString(): value?.id};
  }

  @override
  GenericPaginatedDropDownInput copyWith({
    String? id,
    ValueGetter<String?>? label,
    List<Validator<SimpleLookupItem?>>? validators,
    ValueGetter<dynamic>? value,
    String? toJsonKey,
    String? fromJsonKey,
    List<String>? subordinateKey,
    String? superordinateKey,
    String? customEndPointKey,
    bool? isAlreadyTranslated,
    ValueGetter<String?>? placeHolder,
    UiTypeEnum? uiType,
    LookupDropDownType? lookupDropDownType,
    ValueGetter<SimpleLookupItem? Function(Map<String, dynamic>)?>?
        valueFromJsonFunction,
    ValueGetter<Future<Map<String, dynamic>> Function(SimpleLookupItem?)?>?
        valueToJsonFunction,
    bool? isDisabled,
  }) {
    return GenericPaginatedDropDownInput.pure(
      subordinateKey: subordinateKey ?? this.subordinateKey,
      superordinateKey: superordinateKey ?? this.superordinateKey,
      validators: validators ?? this.validators,
      value: value != null ? value() as SimpleLookupItem? : this.value,
      id: id ?? this.id,
      label: label != null ? label() : this.label,
      isAlreadyTranslated: isAlreadyTranslated ?? this.isAlreadyTranslated,
      toJsonKey: toJsonKey ?? this.toJsonKey,
      fromJsonKey: fromJsonKey ?? this.fromJsonKey,
      lookupDropDownType: lookupDropDownType ?? this.lookupDropDownType,
      customEndPointKey: customEndPointKey ?? this.customEndPointKey,
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
