import 'package:flutter/material.dart';
import 'package:utils_package/utils_package.dart';
import 'package:formz_example/shared/generic_inputs/form_title_no_input.dart';

class FormInnerTitle extends StatelessWidget {
  const FormInnerTitle(this.genericInput, {super.key});
  final FormTitleNoInput genericInput;

  @override
  Widget build(BuildContext context) {
    return CustomText(
      genericInput.translate
          ? genericInput.value.tr(context)
          : genericInput.value,
      color: genericInput.color ?? ColorsManager.darkGreyForTxt,
      fontWeight: genericInput.fontWeight ?? FontWeightManager.bold,
      fontSize: genericInput.fontSize ?? FontSize.f18,
      textAlign: genericInput.textAlign ?? TextAlign.start,
      height: 1.2,
    );
  }
}
