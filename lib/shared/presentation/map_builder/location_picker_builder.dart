import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waste_management/features/map/domain/entities/location_data.dart';
import 'package:waste_management/features/map/presentation/widgets/location_picker.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';

Widget buildLocationPicker<C extends AsyncFormCubitBase>(String inputKey,
    BuildContext context, GenericAsyncInput<LocationData> genericInput) {
  return LocationPicker(
      initLocationData: genericInput.value,
      onLocationSelected: (location) {
        if (location == null) return;
        context.read<C>().updateInput<LocationData>(
              inputKey,
              location,
            );
      });
}
