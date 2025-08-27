import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utils_package/utils_package.dart';
import 'package:waste_management/features/lookups/domain/entities/simple_lookup_item.dart';
import 'package:waste_management/features/lookups/presentation/bloc/lookups_bloc.dart';
import 'package:waste_management/features/lookups/presentation/widgets/paginated_drop_down.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/generic_inputs/generic_paginated_drop_down_input.dart';
import 'package:formz_example/shared/models/formz_state/formz_state.dart';

Widget buildPaginatedDropDown<C extends AsyncFormCubitBase>(
    BuildContext context,
    FormzBaseState state,
    String inputKey,
    GenericPaginatedDropDownInput genericInput) {
  SimpleLookupItem? dependentSelectedItem;
  if (genericInput.superordinateKey != null) {
    final dependentValue =
        state.currentStep.inputs[genericInput.superordinateKey!]!.value;
    'dependentValue: $dependentValue'.dLog("Room920");
    if (dependentValue != null) {
      dependentSelectedItem = dependentValue as SimpleLookupItem?;
    }
  }

  dependentSelectedItem.dLog("Room920");

  final bool isAlreadyTranslated = genericInput.isAlreadyTranslated;

  return PaginatedDropDown(
    //***  please don't pray I die because of the line below ^-^
    needsTranslation: !isAlreadyTranslated,

    superOrdinateId: dependentSelectedItem?.id,
    isEnabled: genericInput.isDisabled
        ? false
        : (genericInput.superordinateKey == null) ||
            (genericInput.superordinateKey != null &&
                dependentSelectedItem != null),
    lookupDropDownType: genericInput.lookupDropDownType,
    customEndpointKey: genericInput.customEndPointKey,
    initSelected: genericInput.value,
    hintText: genericInput.label?.tr(context),
    labelText: genericInput.label?.tr(context),
    onSelected: (value) {
      context.read<C>().updateInput<SimpleLookupItem?>(
            inputKey,
            value..id.dLog("PaginatedDropDown onSelected: $value"),
          );
      if (genericInput.subordinateKey != null) {
        for (final key in genericInput.subordinateKey!) {
          LookupsBloc.get(context).add(ClearLookupEvent(
              (state.currentStep.inputs[key] as GenericPaginatedDropDownInput)
                  .lookupDropDownType));
          context.read<C>().updateInput<SimpleLookupItem?>(
                key,
                null,
              );
        }
      }
    },
  );
}
