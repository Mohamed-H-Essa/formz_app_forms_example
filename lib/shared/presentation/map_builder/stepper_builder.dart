import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utils_package/utils_package.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';
import 'package:waste_management/src/widgets/stepper/app_stepper_widget.dart';

Widget buildStepper<C extends AsyncFormCubitBase>({
  final bool isEdit = false,
  final bool isCompleted = false,
  final bool allTabsOpen = false,
}) {
  return BlocBuilder<C, FormzBaseState>(
    builder: (context, state) {
      return AppStepperWidget(
        isEdit: isEdit,
        allTabsOpen: allTabsOpen,
        onChange: (int index) {
          context.read<C>().toStep(index);
        },
        erroneousSteps: state.erroneousSteps,
        currentIndex: state.currentStepIndex,
        isCompleted: isCompleted,
        steps: state.steps.map((s) => s.stepTitle.tr(context)).toList(),
      );
    },
  );
}
