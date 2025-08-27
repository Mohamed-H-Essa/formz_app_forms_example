part of 'generic_input.dart';

class GenericAsyncInput<T> extends GenericInput<T> with AsyncToJson {
  const GenericAsyncInput.pure({
    required super.value,
    required super.uiType,
    super.isDisabled = false,
    super.id = '',
    super.label,
    super.toJsonKey,
    super.placeHolder,
    super.validators = const [],
    super.fromJsonKey,
    super.isAlreadyTranslated = true,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
  }) : super.pure();

  const GenericAsyncInput.dirty({
    super.id = '',
    super.label,
    required super.value,
    required super.uiType,
    super.isDisabled = false,
    super.toJsonKey,
    super.fromJsonKey,
    super.placeHolder,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
    super.isAlreadyTranslated = true,
    super.validators = const [],
  }) : super.dirty();

  @override
  GenericAsyncInput<T> copyWith({
    String? id,
    ValueGetter<String?>? label,
    ValueGetter<String?>? placeHolder,
    List<Validator<T>>? validators,
    ValueGetter<dynamic>? value,
    String? toJsonKey,
    String? fromJsonKey,
    UiTypeEnum? uiType,
    ValueGetter<T Function(Map<String, dynamic>)?>? valueFromJsonFunction,
    ValueGetter<Future<Map<String, dynamic>> Function(T)?>? valueToJsonFunction,
    bool? isAlreadyTranslated,
    bool? isDisabled,
  }) {
    bool valueIsEmpty = false;
    try {
      valueIsEmpty = (value?.call()).isEmpty ? true : false;
    } catch (e) {
      valueIsEmpty = false;
    }
    if (isPure && value == null || (value?.call()) == null || valueIsEmpty) {
      return GenericAsyncInput<T>.pure(
        id: id ?? this.id,
        validators: validators ?? this.validators,
        label: label != null ? label() : this.label,
        uiType: uiType ?? this.uiType,
        value: value != null ? value() as T : this.value,
        placeHolder:
            placeHolder != null ? placeHolder.call() : this.placeHolder,
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
    } else {
      return GenericAsyncInput<T>.dirty(
        id: id ?? this.id,
        validators: validators ?? this.validators,
        label: label != null ? label() : this.label,
        uiType: uiType ?? this.uiType,
        value: value != null ? value() as T : this.value,
        placeHolder:
            placeHolder != null ? placeHolder.call() : this.placeHolder,
        toJsonKey: toJsonKey ?? this.toJsonKey,
        isAlreadyTranslated: isAlreadyTranslated ?? this.isAlreadyTranslated,
        fromJsonKey: fromJsonKey ?? this.fromJsonKey,
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

  T jsonToValue(Map<String, dynamic> json) {
    if (fromJsonKey != null && json.containsKey(fromJsonKey!)) {
      return json[fromJsonKey!] as T;
    } else {
      throw Exception('No fromJson or fromJsonKey provided for $T');
    }
  }

  @override
  Future<Map<String, dynamic>> toJson() async {
    if (valueToJsonFunction != null) {
      return valueToJsonFunction!(value);
    }
    if (toJsonKey == null) {
      return {};
    }
    final res = {
      toJsonKey!: value is AttachmentItem
          ? value is LocalAttachmentItem
              ? await getMultipartFileFromPath(
                  (value as LocalAttachmentItem).url)
              : null
          : value
    };
    return res;
  }

  @override
  T valueFromJson(Map<String, dynamic> json) {
    if (valueFromJsonFunction != null) {
      return valueFromJsonFunction!(json);
    }
    if (fromJsonKey != null &&
        json.containsKey(fromJsonKey!) &&
        json[fromJsonKey!] != null) {
      return json[fromJsonKey!].toString() as T;
    } else {
      return value;
    }
  }

  @override
  valueToJson(T value) async {
    if (valueToJsonFunction != null) {
      return await valueToJsonFunction!(value);
    }
    if (toJsonKey != null) {
      return {toJsonKey!: value};
    } else {
      return {value.hashCode.toString(): value};
    }
  }
}
