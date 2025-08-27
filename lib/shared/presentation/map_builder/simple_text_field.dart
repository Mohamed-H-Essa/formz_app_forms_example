import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utils_package/utils_package.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/extension/to_input_type_extention.dart';
import 'package:formz_example/shared/extension/to_string_error_extention.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';

Widget buildSimpleTextField<C extends AsyncFormCubitBase>(
    BuildContext context,
    FormzBaseState state,
    String inputKey,
    GenericAsyncInput<String> genericInput) {
  return CustomTextField(
    textInputType: genericInput.uiType.toInputType(),
    isOptional: !genericInput.isRequired,
    labelText: (genericInput.label?.tr(context) ?? ''),
    initialValue: genericInput.value,
    enabled: !genericInput.isDisabled,
    key: ValueKey(genericInput.customHash),
    onChanged: (value) => context.read<C>().updateInput<String>(
          inputKey,
          value,
        ),
    expand: genericInput.uiType == UiTypeEnum.expandedText,
    isPassword: genericInput.uiType == UiTypeEnum.password,
    hintText: genericInput.label?.tr(context),
    errorText: genericInput.displayError?.tr(context),
  );
}
