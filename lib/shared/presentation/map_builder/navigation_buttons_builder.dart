import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:utils_package/utils_package.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';

Widget buildNavigationButtons<C extends AsyncFormCubitBase>(
    {bool isClickable = true, String? text}) {
  return BlocConsumer<C, FormzBaseState>(
    listenWhen: (previous, current) => previous.status != current.status,
    listener: (context, state) {},
    builder: (context, state) {
      final onTap = (!isClickable
          ? null
          : ((state.currentStepIndex) < state.steps.length - 1) &&
                  state.validateCurrentStep()
              ? () {
                  context.read<C>().nextStep();
                }
              : state.isAllValid
                  ? () => context.read<C>().submitForm()
                  : null);
      return CustomContainer(
        //do not add width please
        color: state.validateCurrentStep() && isClickable && !(onTap == null)
            ? ColorsManager.primaryButtonBackground
            : ColorsManager.inactiveButton,
        isLoading: state.currentStep.status == FormzSubmissionStatus.inProgress,
        text: (text ??
                (state.currentStepIndex < state.steps.length - 1
                    ? StringsManager.next
                    : StringsManager.sendRequest))
            .tr(context),
        onTap: onTap..toString().dLog('Room911'),
      );
    },
  );
}
