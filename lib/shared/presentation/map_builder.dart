import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz_example/debug_extension.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/extension/to_string_error_extention.dart';
import 'package:formz_example/shared/generic_inputs/generic_input.dart';
import 'package:formz_example/shared/models/formz_state.dart';

class MapBuilder<C extends FormCubitBase> extends StatelessWidget {
  MapBuilder({
    super.key,
    required this.formMap,
  }) : assert(C != dynamic, 'Generic parameter C must be specified');
  final Map<String, GenericInput> formMap;

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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: formMap.entries.map((entry) {
            final GenericInput input = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildFieldWidget(context, state, entry.key, input),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFieldWidget(BuildContext context, FormzBaseState state,
      String inputId, GenericInput genericInput) {
    // final inputId = genericInput.id;
    switch (genericInput.uiType) {
      case UiTypeEnum.simpleTextField:
        return _buildSimpleTextField(context, state, inputId, genericInput);
      case UiTypeEnum.email:
        return _buildEmailField(context, state, inputId, genericInput);
      case UiTypeEnum.password:
        return _buildPasswordField(context, state, inputId, genericInput);
      // case UiTypeEnum.password:
      //   return _buildConfirmPasswordField(context, state, FormKeys);
      case UiTypeEnum.number:
        return _buildAgeField(context, state, inputId, genericInput);
        return _buildLastNameField(context, state, inputId, genericInput);
      // case UiTypeEnum.dob:
      //   return _buildDateOfBirthField(context, state, inputId);
      case UiTypeEnum.phone:
        return _buildPhoneField(context, state, inputId, genericInput);
      case UiTypeEnum.expandedText:
        return _buildAddressField(context, state, inputId, genericInput);
      case UiTypeEnum.multiInput:
        return _buildNotificationChannelField(
            context, state, inputId, genericInput);
      case UiTypeEnum.checkbox:
        return _buildTermsField(context, state, inputId, genericInput);
      case UiTypeEnum.location:
        throw UnimplementedError();
      case UiTypeEnum.file:
        throw UnimplementedError();
      case UiTypeEnum.dropdown:
        throw UnimplementedError();
      case UiTypeEnum.radioButton:
        throw UnimplementedError();
      case UiTypeEnum.datePicker:
        throw UnimplementedError();
      case UiTypeEnum.timePicker:
        throw UnimplementedError();
      case UiTypeEnum.slider:
        throw UnimplementedError();
      case UiTypeEnum.toggle:
        throw UnimplementedError();
      case UiTypeEnum.button:
        throw UnimplementedError();
      case UiTypeEnum.image:
        throw UnimplementedError();
      case UiTypeEnum.video:
        throw UnimplementedError();
      case UiTypeEnum.audio:
        throw UnimplementedError();
      case UiTypeEnum.map:
        throw UnimplementedError();
      case UiTypeEnum.calendar:
        throw UnimplementedError();
      case UiTypeEnum.colorPicker:
        throw UnimplementedError();
      case UiTypeEnum.rating:
        throw UnimplementedError();
      case UiTypeEnum.signature:
        throw UnimplementedError();
      case UiTypeEnum.barcode:
        throw UnimplementedError();
      case UiTypeEnum.qrCode:
        throw UnimplementedError();
      case UiTypeEnum.richText:
        throw UnimplementedError();
      case UiTypeEnum.markdown:
        throw UnimplementedError();
      case UiTypeEnum.url:
        throw UnimplementedError();
      case UiTypeEnum.currency:
        throw UnimplementedError();
      case UiTypeEnum.percentage:
        throw UnimplementedError();
      case UiTypeEnum.duration:
        throw UnimplementedError();
      case UiTypeEnum.range:
        throw UnimplementedError();
      case UiTypeEnum.multiSelect:
        throw UnimplementedError();
      case UiTypeEnum.autocomplete:
        throw UnimplementedError();
      case UiTypeEnum.tags:
        throw UnimplementedError();
      case UiTypeEnum.chip:
        throw UnimplementedError();
      default:
        return _buildSimpleTextField(context, state, inputId, genericInput);
    }
  }

  Widget _buildEmailField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
    input?.error.toString().debug('input?.error.');
    input?.displayError
        ?.tr(context)
        .toString()
        .debug('input?.displayError?.tr(context).');
    input?.isPure.toString().debug('input?.isPure.');
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${key}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            inputKey,
            value,
          ),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
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

  Widget _buildConfirmPasswordField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      onChanged: (value) => context.read<C>().updateInput<String>(
            inputKey,
            value,
          ),
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildAgeField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
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

  Widget _buildSimpleTextField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      key: ValueKey(genericInput.customHash),
      onChanged: (value) => context.read<C>().updateInput<String>(
            inputKey,
            value,
          ),
      decoration: InputDecoration(
        labelText: genericInput.label,
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLastNameField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      onChanged: (value) => context.read<C>().updateInput<String>(
            inputKey,
            value,
          ),
      decoration: InputDecoration(
        labelText: 'Last Name',
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateOfBirthField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      onChanged: (value) => context.read<C>().updateInput<String>(
            inputKey,
            value,
          ),
      decoration: InputDecoration(
        labelText: 'Date of Birth (DD/MM/YYYY)',
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      onChanged: (value) => context.read<C>().updateInput<String>(
            inputKey,
            value,
          ),
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Phone (10 digits)',
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildAddressField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      onChanged: (value) => context.read<C>().updateInput<String>(
            inputKey,
            value,
          ),
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Address (Optional)',
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildNotificationChannelField(BuildContext context,
      FormzBaseState state, String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
    final notificationOptions = ['Email', 'SMS', 'Push Notification', 'None'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferred Notification Channel',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8.0),
        ...List.generate(notificationOptions.length, (index) {
          final option = notificationOptions[index];
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: input?.value,
            onChanged: (value) {
              if (value != null) {
                context.read<C>().updateInput<String>(
                      inputKey,
                      value,
                    );
              }
            },
          );
        }),
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

  Widget _buildTermsField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<bool>?;
    final isChecked = input?.value ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: const Text('I accept the Terms and Conditions'),
          value: isChecked,
          onChanged: (value) {
            context.read<C>().updateInput<bool>(
                  inputKey,
                  value ?? false,
                );
          },
          controlAffinity: ListTileControlAffinity.leading,
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

  Widget _buildGenericTextField(BuildContext context, FormzBaseState state,
      String inputKey, GenericInput genericInput) {
    final input = state.currentStep.inputs[inputKey] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      onChanged: (value) => context.read<C>().updateInput<String>(
            inputKey,
            value,
          ),
      decoration: InputDecoration(
        labelText: _getFieldLabel(inputKey),
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  String _getFieldLabel(String inputKey) {
    return 'label $inputKey';
    // switch (InputKeys) {
    //   case InputKeys.email:
    //     return 'Email';
    //   case InputKeys.password:
    //     return 'Password';
    //   case InputKeys.confirmPassword:
    //     return 'Confirm Password';
    //   case InputKeys.age:
    //     return 'Age';
    //   case InputKeys.firstName:
    //     return 'First Name';
    //   case InputKeys.lastName:
    //     return 'Last Name';
    //   case InputKeys.dob:
    //     return 'Date of Birth';
    //   case InputKeys.phone:
    //     return 'Phone';
    //   case InputKeys.address:
    //     return 'Address';
    //   case InputKeys.notificationChannel:
    //     return 'Notification Channel';
    //   case InputKeys.termsAccepted:
    //     return 'Terms Accepted';
    // }
  }
}
