import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/extension/to_string_error_extention.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';

Widget buildAgeField<C extends AsyncFormCubitBase>(BuildContext context,
    FormzBaseState state, String inputKey, GenericAsyncInput genericInput) {
  final input =
      state.currentStep.inputs[inputKey] as GenericAsyncInput<String>?;
  return TextFormField(
    initialValue: input?.value,
    key: Key('mapBuilder_${inputKey}_textField'),
    onChanged: (value) => context.read<C>().updateInput<String>(
          inputKey,
          value,
        ),
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: 'Age',
      helperText: 'Must be between 18 and 120',
      errorText: input?.displayError?.tr(context),
      prefixIcon: const Icon(Icons.person),
      border: const OutlineInputBorder(),
    ),
  );
}
