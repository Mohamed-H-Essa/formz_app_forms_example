import 'package:flutter/material.dart';
import 'package:formz_example/shared/enum/input_error_enum.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/validators/validator_type.dart';

class FormTitleNoInput extends GenericAsyncInput<String> {
  final TextAlign? textAlign;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final bool translate;
  FormTitleNoInput(
    String title, {
    super.fromJsonKey,
    super.toJsonKey,
    super.isDisabled = false,
    this.textAlign,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.translate = true,
  }) : super.pure(
          validators: [],
          label: title,
          value: title,
          uiType: UiTypeEnum.titlePlaceHolderNoInput,
        );
  @override
  Future<Map<String, dynamic>> toJson() async {
    return {};
  }

  @override
  InputErrorEnum? validator(void value) {
    return null;
  }

  @override
  List<Validator<void>> get validators => [];

  @override
  String toString() {
    return 'FormTitleNoInput{$label}';
  }

  @override
  FormTitleNoInput copyWith({
    String? id,
    ValueGetter<String?>? label,
    ValueGetter<String?>? placeHolder,
    List<Validator<String>>? validators,
    ValueGetter<dynamic>? value,
    String? toJsonKey,
    String? fromJsonKey,
    UiTypeEnum? uiType,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    bool? translate,
    bool? isAlreadyTranslated,
    ValueGetter<Function(Map<String, dynamic>)?>? valueFromJsonFunction,
    ValueGetter<Future<Map<String, dynamic>> Function(String)?>?
        valueToJsonFunction,
    bool? isDisabled,
  }) {
    return FormTitleNoInput(
      value?.call() as String? ?? this.value,
      fromJsonKey: fromJsonKey ?? this.fromJsonKey,
      toJsonKey: toJsonKey ?? this.toJsonKey,
      textAlign: textAlign ?? this.textAlign,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      color: color ?? this.color,
      translate: translate ?? this.translate,
    );
  }
}
