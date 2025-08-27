import 'package:flutter/material.dart';
import 'package:utils_package/utils_package.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/validators/validator_type.dart';
import 'generic_input/generic_input.dart';

class GenericMultiAttachmentInput extends GenericAsyncInput<AttachmentItem> {
  const GenericMultiAttachmentInput.dirty({
    required super.validators,
    required super.value,
    super.isDisabled = false,
    super.placeHolder,
    super.label,
    super.id,
    super.isAlreadyTranslated = true,
    super.toJsonKey,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
  }) : super.dirty(uiType: UiTypeEnum.multiAttachmentsPicker);

  const GenericMultiAttachmentInput.pure({
    required super.validators,
    required super.value,
    super.isDisabled = false,
    super.placeHolder,
    super.label,
    super.id,
    super.toJsonKey,
    super.isAlreadyTranslated = true,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
  }) : super.pure(uiType: UiTypeEnum.multiAttachmentsPicker);
  @override
  GenericMultiAttachmentInput copyWith({
    String? id,
    ValueGetter<String?>? label,
    List<Validator<AttachmentItem>>? validators,
    ValueGetter<dynamic>? value,
    String? toJsonKey,
    String? fromJsonKey,
    ValueGetter<String?>? placeHolder,
    UiTypeEnum? uiType,
    bool? isAlreadyTranslated,
    ValueGetter<AttachmentItem Function(Map<String, dynamic>)?>?
        valueFromJsonFunction,
    ValueGetter<Future<Map<String, dynamic>> Function(AttachmentItem)?>?
        valueToJsonFunction,
    bool? isDisabled,
  }) {
    return GenericMultiAttachmentInput.dirty(
      validators: validators ?? this.validators,
      value: value != null ? value() as AttachmentItem : this.value,
      id: id ?? this.id,
      label: label != null ? label() : this.label,
      isAlreadyTranslated: isAlreadyTranslated ?? this.isAlreadyTranslated,
      toJsonKey: toJsonKey ?? this.toJsonKey,
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
