import 'package:flutter/material.dart';
import 'package:utils_package/utils_package.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';

Widget buildVerticalSpace<C extends AsyncFormCubitBase>(
        GenericAsyncInput<num> genericInput) =>
    genericInput.value.spaceH;
