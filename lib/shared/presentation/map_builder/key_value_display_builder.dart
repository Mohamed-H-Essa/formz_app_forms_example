import 'package:flutter/material.dart';
import 'package:utils_package/utils_package.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';

Widget buildKeyValueDisplay<C extends AsyncFormCubitBase>(
    BuildContext context,
    FormzBaseState state,
    String inputKey,
    GenericAsyncInput<String> genericInput) {
  final value = genericInput.value;
  final keyString = genericInput.label;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            (keyString ?? '').tr(context),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}
