import 'package:flutter/material.dart';
import 'package:utils_package/utils_package.dart';
import 'package:waste_management/src/core/functions/get_multi_part_file_from_path.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/validators/validator_type.dart';
import 'package:waste_management/src/widgets/attachment_picker/multi_attachment_selector.dart';

class GenericAsyncMultiAttachmentSelector
    extends GenericAsyncInput<List<MultiAttachmentSelectorItem>> {
  const GenericAsyncMultiAttachmentSelector.pure({
    required super.validators,
    required super.value,
    super.id = '',
    super.label,
    super.toJsonKey,
    super.placeHolder,
    super.fromJsonKey,
    super.isAlreadyTranslated = true,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
    super.isDisabled = false,
  }) : super.pure(uiType: UiTypeEnum.multiAttachmentsPicker);

  const GenericAsyncMultiAttachmentSelector.dirty({
    super.id = '',
    super.label,
    required super.validators,
    required super.value,
    required super.uiType,
    super.toJsonKey,
    super.fromJsonKey,
    super.placeHolder,
    super.valueFromJsonFunction,
    super.valueToJsonFunction,
    super.isDisabled = false,
    super.isAlreadyTranslated = true,
  }) : super.dirty();

  @override
  GenericAsyncMultiAttachmentSelector copyWith({
    String? id,
    ValueGetter<String?>? label,
    ValueGetter<String?>? placeHolder,
    List<Validator<List<MultiAttachmentSelectorItem>>>? validators,
    ValueGetter<dynamic>? value,
    String? toJsonKey,
    String? fromJsonKey,
    UiTypeEnum? uiType,
    bool? isAlreadyTranslated,
    ValueGetter<
            List<MultiAttachmentSelectorItem> Function(Map<String, dynamic>)?>?
        valueFromJsonFunction,
    ValueGetter<
            Future<Map<String, dynamic>> Function(
                List<MultiAttachmentSelectorItem>)?>?
        valueToJsonFunction,
    bool? isDisabled,
  }) {
    if (isPure && value == null ||
        (value?.call()) == null ||
        (value?.call() as List<MultiAttachmentSelectorItem>).isEmpty) {
      return GenericAsyncMultiAttachmentSelector.pure(
        id: id ?? this.id,
        validators: validators ?? this.validators,
        label: label != null ? label() : this.label,
        isAlreadyTranslated: isAlreadyTranslated ?? this.isAlreadyTranslated,
        value: value != null
            ? value() as List<MultiAttachmentSelectorItem>
            : this.value,
        placeHolder:
            placeHolder != null ? placeHolder.call() : this.placeHolder,
        toJsonKey: toJsonKey ?? this.toJsonKey,
        fromJsonKey: fromJsonKey ?? this.fromJsonKey,
        valueFromJsonFunction: valueFromJsonFunction != null
            ? valueFromJsonFunction()
            : this.valueFromJsonFunction,
        valueToJsonFunction: valueToJsonFunction != null
            ? valueToJsonFunction()
            : this.valueToJsonFunction,
        isDisabled: isDisabled ?? this.isDisabled,
      );
    } else {
      return GenericAsyncMultiAttachmentSelector.dirty(
        id: id ?? this.id,
        validators: validators ?? this.validators,
        label: label != null ? label() : this.label,
        uiType: uiType ?? this.uiType,
        value: value != null
            ? value() as List<MultiAttachmentSelectorItem>
            : this.value,
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

  @override
  List<MultiAttachmentSelectorItem> jsonToValue(Map<String, dynamic> json) {
    if (fromJsonKey != null && json.containsKey(fromJsonKey!)) {
      final List<MultiAttachmentSelectorItem> result = [];
      for (final item in json[fromJsonKey!] as List<dynamic>) {
        if (item is Map<String, dynamic>) {
          result.add(MultiAttachmentSelectorItem.fromJson(item));
        } else if (item is MultiAttachmentSelectorItem) {
          result.add(item);
        } else {
          throw Exception(
              'Invalid type for MultiAttachmentSelectorItem: ${item.runtimeType}');
        }
      }

      return result;
    } else {
      throw Exception(
          'No fromJson or fromJsonKey provided for GenericAsyncmultiAttachementSelector');
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
    final Map<String, dynamic> res = {};

    for (var i = 0; i < value.length; i++) {
      if (value[i].attachment == null || value[i].attachment!.url.isEmpty) {
        continue;
      }
      res.addAll(value[i].attachment is LocalAttachmentItem
          ? {
              '${toJsonKey ?? 'additional_documents'}[$i][file]':
                  await getMultipartFileFromPath(value[i].attachment!.url),
              '${toJsonKey ?? 'additional_documents'}[$i][name]':
                  value[i].attachmentName.trim().isEmpty
                      ? value[i].attachment!.name
                      : value[i].attachmentName.trim(),
            }
          : {
              '${toJsonKey ?? 'additional_documents'}[$i][id]':
                  (value[i].attachment! as OnlineAttachmentItem).id,
              '${toJsonKey ?? 'additional_documents'}[$i][name]':
                  value[i].attachmentName.trim().isEmpty
                      ? value[i].attachment!.name
                      : value[i].attachmentName.trim(),
            });
    }
    return res;
  }

  @override
  List<MultiAttachmentSelectorItem> valueFromJson(Map<String, dynamic> json) {
    if (valueFromJsonFunction != null) {
      return valueFromJsonFunction!(json);
    }
    if (fromJsonKey != null &&
        json.containsKey(fromJsonKey!) &&
        json[fromJsonKey!].containsKey('data')) {
      final List<MultiAttachmentSelectorItem> result =
          <MultiAttachmentSelectorItem>[];
      for (final item in json[fromJsonKey!]['data'] as List<dynamic>) {
        if (item is Map<String, dynamic>) {
          result.add(MultiAttachmentSelectorItem.fromJson(item));
        } else if (item is MultiAttachmentSelectorItem) {
          result.add(item);
        } else {
          throw Exception(
              'Invalid type for MultiAttachmentSelectorItem: ${item.runtimeType}');
        }
      }
      return result;
    } else {
      return value;
    }
  }

  @override
  valueToJson(List<MultiAttachmentSelectorItem> value) async {
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
