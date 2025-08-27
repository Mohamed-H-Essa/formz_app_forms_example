import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utils_package/utils_package.dart';
import 'package:waste_management/features/lookups/domain/entities/simple_lookup_item.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/generic_inputs/generic_static_drop_down_input.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';

Widget buildStaticDropDown<C extends AsyncFormCubitBase>(
    BuildContext context,
    FormzBaseState state,
    String inputKey,
    GenericAsyncInput<SimpleLookupItem?> genericInput) {
  final input = state.currentStep.inputs[inputKey]
      as GenericStaticDropDownInput<SimpleLookupItem?>;
  return CustomPaginatedDropdown<SimpleLookupItem>(
    isEnabled: !input.isDisabled,
    selectedItem: genericInput.value,
    isOptional: !genericInput.isRequired,
    labelText: genericInput.label?.tr(context),
    localItemsData: input.localItemsData
        .map((e) => SimpleLookupItem(id: e!.id, name: e.name))
        .toList(),

    onSelected: (SimpleLookupItem value) {
      context.read<C>().updateInput<SimpleLookupItem>(
            inputKey,
            value,
          );
    },
    getItemString: (i) {
      return i.name.tr(context);
    },
    hintText: input.label?.tr(context) ?? '',
    // hintTextStyle: ,
  );
  // return CustomTextField(
  //   textInputType: input?.uiType.toInputType() ?? TextInputType.text,
  //   labelText: genericInput.label,
  //   initialValue: input?.value,
  //   key: ValueKey(genericInput.customHash),
  //   onChanged: (value) => context.read<C>().updateInput<String>(
  //         inputKey,
  //         value,
  //       ),
  //   hintText: genericInput.label,
  //   errorText: input?.displayError?.tr(context),
  // );
}
