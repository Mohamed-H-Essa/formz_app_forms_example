import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utils_package/utils_package.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/extension/to_string_error_extention.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';

Widget buildCheckBox<C extends AsyncFormCubitBase>(BuildContext context,
    FormzBaseState state, String inputKey, GenericAsyncInput genericInput) {
  final input = state.currentStep.inputs[inputKey] as GenericAsyncInput<int>?;
  final isChecked = input?.value ?? 0;
  isChecked.dLog('isChecked: $isChecked');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: isChecked == 1,
              activeColor: ColorsManager.primaryButtonBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: BorderSide(
                color: Colors.grey.shade400,
                width: 1.5,
              ),
              onChanged: (value) {
                if (value == null) return;
                context.read<C>().updateInput<int>(
                      inputKey,
                      value ? 1 : 0,
                    );
              },
            ),
          ),
          // const SizedBox(width: 12),
          Expanded(
            child: CustomText(
              genericInput.label?.tr(context) ?? '',
              fontSize: FontSize.textSizeBody_14,
              fontWeight: FontWeightManager.regular,
              lineHeight: AppSize.s20,
              color: ColorsManager.mediumGreyForTxt,
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
      if (input?.displayError?.tr(context) != null)
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            input!.displayError!.tr(context),
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12.0,
            ),
          ),
        ),
    ],
  );
}
