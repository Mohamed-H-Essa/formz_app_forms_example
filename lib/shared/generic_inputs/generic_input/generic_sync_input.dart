part of 'generic_input.dart';

class GenericSyncInput<T> extends GenericInput<T> with SyncToJson {
  const GenericSyncInput.pure({
    required super.validators,
    required super.value,
    required super.uiType,
    super.isDisabled = false,
    super.isAlreadyTranslated = true,
    super.id = '',
    super.label,
    super.toJsonKey,
    super.placeHolder,
    super.fromJsonKey,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
    Map<String, dynamic> Function()? customToJson,
  }) : super.pure();

  const GenericSyncInput.dirty({
    super.id = '',
    super.label,
    required super.validators,
    required super.value,
    super.isDisabled = false,
    super.toJsonKey,
    super.fromJsonKey,
    super.placeHolder,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
    super.isAlreadyTranslated = true,
    Map<String, dynamic> Function()? customToJson,
  }) : super.dirty(uiType: UiTypeEnum.multiAttachmentsPicker);

  @override
  GenericSyncInput<T> copyWith({
    String? id,
    ValueGetter<String?>? label,
    ValueGetter<String?>? placeHolder,
    List<Validator<T>>? validators,
    ValueGetter<T>? value,
    String? toJsonKey,
    String? fromJsonKey,
    UiTypeEnum? uiType,
    bool? isDisabled,
    ValueGetter<T Function(Map<String, dynamic>)?>? valueFromJsonFunction,
    bool? isAlreadyTranslated,
  }) {
    bool valueIsEmpty = false;
    try {
      valueIsEmpty = (value?.call() as String).isEmpty ? true : false;
    } catch (e) {
      valueIsEmpty = false;
    }
    if (isPure && value == null || (value?.call()) == null || valueIsEmpty) {
      return GenericSyncInput.pure(
        id: id ?? this.id,
        validators: validators ?? this.validators,
        label: label != null ? label() : this.label,
        isAlreadyTranslated: isAlreadyTranslated ?? this.isAlreadyTranslated,
        uiType: uiType ?? this.uiType,
        value: value != null ? value() : this.value,
        placeHolder:
            placeHolder != null ? placeHolder.call() : this.placeHolder,
        toJsonKey: toJsonKey ?? this.toJsonKey,
        fromJsonKey: fromJsonKey ?? this.fromJsonKey,
        valueFromJsonFunction: valueFromJsonFunction != null
            ? valueFromJsonFunction()
            : this.valueFromJsonFunction,
        isDisabled: isDisabled ?? this.isDisabled,
      );
    } else {
      return GenericSyncInput.dirty(
        id: id ?? this.id,
        validators: validators ?? this.validators,
        label: label != null ? label() : this.label,
        value: value != null ? value() : this.value,
        placeHolder:
            placeHolder != null ? placeHolder.call() : this.placeHolder,
        toJsonKey: toJsonKey ?? this.toJsonKey,
        fromJsonKey: fromJsonKey ?? this.fromJsonKey,
        valueFromJsonFunction: valueFromJsonFunction != null
            ? valueFromJsonFunction()
            : this.valueFromJsonFunction,
        isDisabled: isDisabled ?? this.isDisabled,
        isAlreadyTranslated: isAlreadyTranslated ?? this.isAlreadyTranslated,
      );
    }
  }

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  valueToJson(T value) {
    // TODO: implement valueToJson
    throw UnimplementedError();
  }
}
