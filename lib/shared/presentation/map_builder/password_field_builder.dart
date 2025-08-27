import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/extension/to_string_error_extention.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';

Widget buildPasswordField<C extends AsyncFormCubitBase>(BuildContext context,
    FormzBaseState state, String inputKey, GenericAsyncInput genericInput) {
  final input =
      state.currentStep.inputs[inputKey] as GenericAsyncInput<String>?;
  return TextFormField(
    initialValue: input?.value,
    onChanged: (value) => context.read<C>().updateInput<String>(
          inputKey,
          value,
        ),
    obscureText: true,
    decoration: InputDecoration(
      labelText: 'Password',
      errorText: input?.displayError?.tr(context),
      border: const OutlineInputBorder(),
    ),
  );
}
