import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utils_package/utils_package.dart';
import 'package:waste_management/features/lookups/domain/entities/simple_lookup_item.dart';
import 'package:waste_management/features/map/domain/entities/location_data.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/extension/to_string_error_extention.dart';
import 'package:formz_example/shared/generic_inputs/form_title_no_input.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/generic_inputs/generic_paginated_drop_down_input.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';
import 'package:formz_example/shared/presentation/map_builder/age_field_builder.dart';
import 'package:formz_example/shared/presentation/map_builder/build_check_box.dart';
import 'package:formz_example/shared/presentation/map_builder/form_inner_title.dart';
import 'package:formz_example/shared/presentation/map_builder/key_value_display_builder.dart';
import 'package:formz_example/shared/presentation/map_builder/location_picker_builder.dart';
import 'package:formz_example/shared/presentation/map_builder/paginated_dropdown_builder.dart';
import 'package:formz_example/shared/presentation/map_builder/simple_text_field.dart';
import 'package:formz_example/shared/presentation/map_builder/static_dropdown_builder.dart';
import 'package:formz_example/shared/presentation/map_builder/vertical_space_builder.dart';
import 'package:waste_management/src/widgets/attachment_picker/multi_attachment_selector.dart';
import 'package:waste_management/src/widgets/attachment_picker/single_attachment_selector.dart';

Widget buildFieldWidget<C extends AsyncFormCubitBase>(BuildContext context,
    FormzBaseState state, String inputId, GenericAsyncInput genericInput) {
  switch (genericInput.uiType) {
    case UiTypeEnum.simpleTextField:
      return buildSimpleTextField<C>(
          context, state, inputId, genericInput as GenericAsyncInput<String>);
    case UiTypeEnum.staticDropdown:
      return buildStaticDropDown<C>(context, state, inputId,
          genericInput as GenericAsyncInput<SimpleLookupItem?>);
    case UiTypeEnum.paginatedDropdown:
      return buildPaginatedDropDown<C>(context, state, inputId,
          genericInput as GenericPaginatedDropDownInput);
    case UiTypeEnum.titlePlaceHolderNoInput:
      return FormInnerTitle(genericInput as FormTitleNoInput);
    case UiTypeEnum.singleAttachmentPicker:
      return SingleAttachmentSelector(
        attachment: genericInput.value,
        isDisabled: genericInput.isDisabled,
        isOptional: !genericInput.isRequired,
        title: genericInput.label?.tr(context) ?? '',
        onAttachmentPicked: (AttachmentItem? attachment) {
          context.read<C>().updateInput<AttachmentItem?>(
                inputId,
                attachment,
              );
        },
      );
    case UiTypeEnum.multiAttachmentsPicker:
      (genericInput as GenericAsyncInput<List<MultiAttachmentSelectorItem>>);

      //!important, should be managed elsewhere later
      if ((genericInput.value.isEmpty ||
              genericInput.value.first.attachment == null) &&
          genericInput.isDisabled) {
        return const SizedBox.shrink();
      }

      return MultiAttachmentSelector(
        errorMessage: genericInput.displayError?.tr(context),
        isOptional: !genericInput.isRequired,
        attachments: genericInput.value,
        isDisabled: genericInput.isDisabled,
        title: genericInput.label?.tr(context) ?? '',
        onAttachmentPicked: (List<MultiAttachmentSelectorItem> attachments) {
          context.read<C>().updateInput<List<MultiAttachmentSelectorItem>>(
                inputId,
                attachments,
              );
        },
        withFileName: genericInput.validators.any(
          (v) => v.toString().contains('additionalFile'),
        ),
      );
    case UiTypeEnum.password:
      return buildSimpleTextField<C>(
          context, state, inputId, genericInput as GenericAsyncInput<String>);
    // case UiTypeEnum.password:
    //   return _buildConfirmPasswordField(context, state, FormKeys);
    case UiTypeEnum.number:
      return buildAgeField<C>(context, state, inputId, genericInput);
    // case UiTypeEnum.dob:
    //   return _buildDateOfBirthField(context, state, inputId);
    case UiTypeEnum.phone:
      return buildSimpleTextField<C>(
          context, state, inputId, genericInput as GenericAsyncInput<String>);
    case UiTypeEnum.expandedText:
      return buildSimpleTextField<C>(
          context, state, inputId, genericInput as GenericAsyncInput<String>);
    case UiTypeEnum.checkbox:
      return buildCheckBox<C>(context, state, inputId, genericInput);
    case UiTypeEnum.verticalSpace:
      return buildVerticalSpace<C>(genericInput as GenericAsyncInput<num>);
    case UiTypeEnum.location:
      return buildLocationPicker<C>(
          inputId, context, genericInput as GenericAsyncInput<LocationData>);
    case UiTypeEnum.radioButton:
      throw UnimplementedError();
    case UiTypeEnum.datePicker:
      throw UnimplementedError();
    case UiTypeEnum.timePicker:
      throw UnimplementedError();
    case UiTypeEnum.slider:
      throw UnimplementedError();
    case UiTypeEnum.toggle:
      throw UnimplementedError();
    case UiTypeEnum.button:
      throw UnimplementedError();
    case UiTypeEnum.image:
      throw UnimplementedError();
    case UiTypeEnum.video:
      throw UnimplementedError();
    case UiTypeEnum.audio:
      throw UnimplementedError();
    case UiTypeEnum.map:
      throw UnimplementedError();
    case UiTypeEnum.calendar:
      throw UnimplementedError();
    case UiTypeEnum.colorPicker:
      throw UnimplementedError();
    case UiTypeEnum.rating:
      throw UnimplementedError();
    case UiTypeEnum.signature:
      throw UnimplementedError();
    case UiTypeEnum.barcode:
      throw UnimplementedError();
    case UiTypeEnum.qrCode:
      throw UnimplementedError();
    case UiTypeEnum.richText:
      throw UnimplementedError();
    case UiTypeEnum.markdown:
      throw UnimplementedError();
    case UiTypeEnum.url:
      throw UnimplementedError();
    case UiTypeEnum.currency:
      throw UnimplementedError();
    case UiTypeEnum.percentage:
      throw UnimplementedError();
    case UiTypeEnum.duration:
      throw UnimplementedError();
    case UiTypeEnum.range:
      throw UnimplementedError();
    case UiTypeEnum.multiSelect:
      throw UnimplementedError();
    case UiTypeEnum.autocomplete:
      throw UnimplementedError();
    case UiTypeEnum.tags:
      throw UnimplementedError();
    case UiTypeEnum.chip:
      throw UnimplementedError();
    case UiTypeEnum.invisibleInput:
      return const SizedBox();
    case UiTypeEnum.keyValueDisplay:
      return buildKeyValueDisplay<C>(
          context, state, inputId, genericInput as GenericAsyncInput<String>);
  }
}
