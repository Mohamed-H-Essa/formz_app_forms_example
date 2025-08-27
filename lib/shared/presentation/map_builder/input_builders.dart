import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';
import 'package:formz_example/shared/presentation/map_builder/field_builder.dart';

class MapBuilder<C extends AsyncFormCubitBase> extends StatelessWidget {
  MapBuilder({
    super.key,
    required this.formMap,
    this.mainAxisAlignment,
  }) : assert(C != dynamic, 'Generic parameter C must be specified');
  final Map<String, GenericAsyncInput> formMap;
  final MainAxisAlignment? mainAxisAlignment;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, FormzBaseState>(
      buildWhen: (previous, current) {
        for (final formKey in formMap.keys) {
          final previousInput = previous.currentStep.inputs[formKey];
          final currentInput = current.currentStep.inputs[formKey];

          if (previousInput?.value != currentInput?.value ||
              previousInput?.isPure != currentInput?.isPure) {
            return true;
          }
        }
        return false;
      },
      builder: (context, state) {
        return Form(
          child: Column(
            mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: formMap.entries.map((entry) {
              final GenericAsyncInput input = entry.value;
              return buildFieldWidget<C>(context, state, entry.key, input);
            }).toList(),
          ),
        );
      },
    );
  }
}
