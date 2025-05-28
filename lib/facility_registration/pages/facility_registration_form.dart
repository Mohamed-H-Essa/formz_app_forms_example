import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/debug_extension.dart';
import 'package:formz_example/facility_registration/cubit/facility_registration_state.dart';
// import 'package:formz_example/form_input_complex.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/enum/form_field_enum.dart';
import 'package:formz_example/shared/extension/to_string_error_extention.dart';
import 'package:formz_example/shared/generic_inputs/generic_input.dart';
import 'package:formz_example/shared/models/formz_state.dart';
import '../cubit/facility_registration_cubit.dart';

class ComplexFormExample extends StatelessWidget {
  const ComplexFormExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complex Form Example'),
      ),
      body: BlocProvider(
        create: (_) => FacilityRegistrationFormCubit(),
        child: const _ComplexFormContent(),
      ),
    );
  }
}

class _ComplexFormContent extends StatefulWidget {
  const _ComplexFormContent({Key? key}) : super(key: key);

  @override
  State<_ComplexFormContent> createState() => _ComplexFormContentState();
}

class _ComplexFormContentState extends State<_ComplexFormContent> {
  final _formSections = [
    'Personal Information',
    'Contact Details',
    'Preferences',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<FacilityRegistrationFormCubit,
          FacilityRegistrationFormzState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepper<FacilityRegistrationFormCubit>(),
              const SizedBox(height: 16.0),
              Text(
                _formSections[state.currentStepIndex],
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildCurrentSection<FacilityRegistrationFormCubit>(),
                ),
              ),
              const SizedBox(height: 16.0),
              _buildNavigationButtons<FacilityRegistrationFormCubit>(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStepper<C extends FormCubitBase>() {
    return BlocBuilder<FacilityRegistrationFormCubit,
        FacilityRegistrationFormzState>(
      builder: (context, state) {
        return Row(
          children: List.generate(
            _formSections.length * 2 - 1,
            (index) {
              if (index.isEven) {
                final stepIndex = index ~/ 2;
                final isActive = stepIndex <= state.currentStepIndex;
                final isCompleted = stepIndex < state.currentStepIndex;

                return Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: state.isErroneous(stepIndex)
                        ? Colors.deepOrange
                        : isActive
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(
                            '${stepIndex + 1}',
                            style: TextStyle(
                              color: isActive
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              } else {
                return Expanded(
                  child: Container(
                    height: 2,
                    color: index < (state.currentStepIndex) * 2
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildCurrentSection<C extends FormCubitBase>() {
    return BlocBuilder<C, FormzBaseState>(builder: (_, __) {
      __.steps.length.toString().debug('__.steps.length ');
      __.steps[0].toString().debug('__.steps[0] ');
      __.steps[0].stepId.toString().debug('__.steps[0].stepId ');
      return MapBuilder<C>(formMap: __.currentStep.inputs);
      // switch (__.currentStepIndex) {
      //   case 1:
      //     // return Container();
      //     return MapBuilder(formMap: __.currentStep.inputs);
      //     return _PersonalInformationForm();
      //   case 2:
      //     return MapBuilder(formMap: __.currentStep.inputs);
      //     return _ContactDetailsForm();
      //   case 3:
      //     return MapBuilder(formMap: __.currentStep.inputs);
      //     return _PreferencesForm();
      //   default:
      //     return const SizedBox();
      // }
    });
  }

  Widget _buildNavigationButtons<C extends FormCubitBase>() {
    return BlocConsumer<C, FormzBaseState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully!')),
          );
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if ((state.currentStepIndex) > 0)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    context.read<C>().previousStep();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black87,
                ),
                child: const Text('Previous'),
              )
            else
              const SizedBox(),
            if ((state.currentStepIndex) < _formSections.length - 1)
              ElevatedButton(
                onPressed: _validateCurrentStep<FacilityRegistrationFormCubit>()
                    ? () {
                        setState(() {
                          context.read<C>().nextStep();
                        });
                      }
                    : null,
                child: const Text('Next'),
              )
            else
              ElevatedButton(
                onPressed:
                    _validateCurrentStep<FacilityRegistrationFormCubit>() &&
                            state.isAllValid
                        ? () => context.read<C>().submit()
                        : null,
                child: state.status == FormzSubmissionStatus.inProgress
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Submit'),
              ),
          ],
        );
      },
    );
  }

  bool _validateCurrentStep<C extends FormCubitBase>() {
    final cubit = context.read<C>();
    final state = cubit.state;

    return state.steps[state.currentStepIndex].isValid;
  }
}

class _PersonalInformationForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFirstNameField(),
        const SizedBox(height: 16.0),
        _buildLastNameField(),
        const SizedBox(height: 16.0),
        _buildDateOfBirthField(),
      ],
    );
  }

  Widget _buildFirstNameField<C extends FormCubitBase>() {
    return BlocBuilder<C, FormzBaseState>(
      buildWhen: (previous, current) {
        final previousInput = previous.currentStep
            .inputs[FormFieldEnum.firstName] as GenericInput<String>?;
        final currentInput = current.currentStep.inputs[FormFieldEnum.firstName]
            as GenericInput<String>?;
        return previousInput?.value != currentInput?.value ||
            previousInput?.isPure != currentInput?.isPure;
      },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.firstName]
            as GenericInput<String>?;
        return TextFormField(
          initialValue: input?.value,
          key: const Key('complexForm_firstName_textField'),
          onChanged: (value) => context.read<C>().updateInput<String>(
                FormFieldEnum.firstName,
                value,
              ),
          decoration: InputDecoration(
            labelText: 'First Name',
            errorText: input?.displayError?.tr(context),
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildLastNameField<C extends FormCubitBase>() {
    return BlocBuilder<C, FormzBaseState>(
      buildWhen: (previous, current) {
        final previousInput = previous.currentStep
            .inputs[FormFieldEnum.lastName] as GenericInput<String>?;
        final currentInput = current.currentStep.inputs[FormFieldEnum.lastName]
            as GenericInput<String>?;
        return previousInput?.value != currentInput?.value ||
            previousInput?.isPure != currentInput?.isPure;
      },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.lastName]
            as GenericInput<String>?;
        return TextFormField(
          initialValue: input?.value,
          key: const Key('complexForm_lastName_textField'),
          onChanged: (value) => context.read<C>().updateInput<String>(
                FormFieldEnum.lastName,
                value,
              ),
          decoration: InputDecoration(
            labelText: 'Last Name',
            errorText: input?.displayError?.tr(context),
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildDateOfBirthField<C extends FormCubitBase>() {
    return BlocBuilder<C, FormzBaseState>(
      buildWhen: (previous, current) {
        final previousInput = previous.currentStep.inputs[FormFieldEnum.dob]
            as GenericInput<String>?;
        final currentInput = current.currentStep.inputs[FormFieldEnum.dob]
            as GenericInput<String>?;
        return previousInput?.value != currentInput?.value ||
            previousInput?.isPure != currentInput?.isPure;
      },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.dob]
            as GenericInput<String>?;
        return TextFormField(
          initialValue: input?.value,
          key: const Key('complexForm_dob_textField'),
          onChanged: (value) => context.read<C>().updateInput<String>(
                FormFieldEnum.dob,
                value,
              ),
          decoration: InputDecoration(
            labelText: 'Date of Birth (DD/MM/YYYY)',
            errorText: input?.displayError?.tr(context),
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _ContactDetailsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildEmailField(),
        const SizedBox(height: 16.0),
        _buildPhoneField(),
        const SizedBox(height: 16.0),
        _buildAddressField(),
      ],
    );
  }

  Widget _buildEmailField<C extends FormCubitBase>() {
    return BlocBuilder<C, FormzBaseState>(
      buildWhen: (previous, current) {
        final previousInput = previous.currentStep.inputs[FormFieldEnum.email]
            as GenericInput<String>?;
        final currentInput = current.currentStep.inputs[FormFieldEnum.email]
            as GenericInput<String>?;
        return previousInput?.value != currentInput?.value ||
            previousInput?.isPure != currentInput?.isPure;
      },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.email]
            as GenericInput<String>?;
        return TextFormField(
          key: const Key('complexForm_email_textField'),
          initialValue: input?.value,
          onChanged: (value) => context.read<C>().updateInput<String>(
                FormFieldEnum.email,
                value,
              ),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: input?.displayError?.tr(context),
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildPhoneField<C extends FormCubitBase>() {
    return BlocBuilder<C, FormzBaseState>(
      buildWhen: (previous, current) {
        final previousInput = previous.currentStep.inputs[FormFieldEnum.phone]
            as GenericInput<String>?;
        final currentInput = current.currentStep.inputs[FormFieldEnum.phone]
            as GenericInput<String>?;
        return previousInput?.value != currentInput?.value ||
            previousInput?.isPure != currentInput?.isPure;
      },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.phone]
            as GenericInput<String>?;
        return TextFormField(
          initialValue: input?.value,
          key: const Key('complexForm_phone_textField'),
          onChanged: (value) => context.read<C>().updateInput<String>(
                FormFieldEnum.phone,
                value,
              ),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone (10 digits)',
            errorText: input?.displayError?.tr(context),
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildAddressField<C extends FormCubitBase>() {
    return BlocBuilder<C, FormzBaseState>(
      buildWhen: (previous, current) {
        final previousInput = previous.currentStep.inputs[FormFieldEnum.address]
            as GenericInput<String>?;
        final currentInput = current.currentStep.inputs[FormFieldEnum.address]
            as GenericInput<String>?;
        return previousInput?.value != currentInput?.value ||
            previousInput?.isPure != currentInput?.isPure;
      },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.address]
            as GenericInput<String>?;
        return TextFormField(
          initialValue: input?.value,
          key: const Key('complexForm_address_textField'),
          onChanged: (value) => context.read<C>().updateInput<String>(
                FormFieldEnum.address,
                value,
              ),
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Address (Optional)',
            errorText: input?.displayError?.tr(context),
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _PreferencesForm extends StatelessWidget {
  final List<String> _notificationOptions = [
    'Email',
    'SMS',
    'Push Notification',
    'None'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildNotificationChannelField(context),
        const SizedBox(height: 16.0),
        _buildTermsAndConditionsCheckbox(),
      ],
    );
  }

  Widget _buildNotificationChannelField<C extends FormCubitBase>(
      BuildContext context) {
    return BlocBuilder<C, FormzBaseState>(
      buildWhen: (previous, current) {
        final previousInput = previous.currentStep
            .inputs[FormFieldEnum.notificationChannel] as GenericInput<String>?;
        final currentInput = current.currentStep
            .inputs[FormFieldEnum.notificationChannel] as GenericInput<String>?;
        return previousInput?.value != currentInput?.value ||
            previousInput?.isPure != currentInput?.isPure;
      },
      builder: (context, state) {
        final input = state.currentStep
            .inputs[FormFieldEnum.notificationChannel] as GenericInput<String>?;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferred Notification Channel',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8.0),
            ...List.generate(_notificationOptions.length, (index) {
              final option = _notificationOptions[index];
              return RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: input?.value,
                onChanged: (value) {
                  if (value != null) {
                    'ui clicked'.debug();
                    context.read<C>().updateInput<String>(
                          FormFieldEnum.notificationChannel,
                          value..debug('UI clicked: '),
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
      },
    );
  }

  Widget _buildTermsAndConditionsCheckbox<C extends FormCubitBase>() {
    return BlocBuilder<C, FormzBaseState>(
      buildWhen: (previous, current) {
        final previousInput = previous.currentStep
            .inputs[FormFieldEnum.termsAccepted] as GenericInput<bool>?;
        final currentInput = current.currentStep
            .inputs[FormFieldEnum.termsAccepted] as GenericInput<bool>?;
        return previousInput?.value != currentInput?.value ||
            previousInput?.isPure != currentInput?.isPure;
      },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.termsAccepted]
            as GenericInput<bool>?;
        final isChecked = input?.value ?? false;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CheckboxListTile(
              title: const Text('I accept the Terms and Conditions'),
              value: isChecked,
              onChanged: (value) {
                context.read<C>().updateInput<bool>(
                      FormFieldEnum.termsAccepted,
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
      },
    );
  }
}

// Dynamic form builder that creates widgets based on form field types
class MapBuilder<C extends FormCubitBase> extends StatelessWidget {
  MapBuilder({
    super.key,
    required this.formMap,
  }) : assert(C != dynamic, 'Generic parameter C must be specified');
  final Map<FormFieldEnum, GenericInput> formMap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<C, FormzBaseState>(
      buildWhen: (previous, current) {
        for (final fieldEnum in formMap.keys) {
          final previousInput = previous.currentStep.inputs[fieldEnum];
          final currentInput = current.currentStep.inputs[fieldEnum];

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
            final fieldEnum = entry.key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildFieldWidget(context, state, fieldEnum),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFieldWidget(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    switch (fieldEnum) {
      case FormFieldEnum.email:
        return _buildEmailField(context, state, fieldEnum);
      case FormFieldEnum.password:
        return _buildPasswordField(context, state, fieldEnum);
      case FormFieldEnum.confirmPassword:
        return _buildConfirmPasswordField(context, state, fieldEnum);
      case FormFieldEnum.age:
        return _buildAgeField(context, state, fieldEnum);
      case FormFieldEnum.firstName:
        return _buildFirstNameField(context, state, fieldEnum);
      case FormFieldEnum.lastName:
        return _buildLastNameField(context, state, fieldEnum);
      case FormFieldEnum.dob:
        return _buildDateOfBirthField(context, state, fieldEnum);
      case FormFieldEnum.phone:
        return _buildPhoneField(context, state, fieldEnum);
      case FormFieldEnum.address:
        return _buildAddressField(context, state, fieldEnum);
      case FormFieldEnum.notificationChannel:
        return _buildNotificationChannelField(context, state, fieldEnum);
      case FormFieldEnum.termsAccepted:
        return _buildTermsField(context, state, fieldEnum);
      default:
        return _buildGenericTextField(context, state, fieldEnum);
    }
  }

  Widget _buildEmailField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
    input?.error.toString().debug('input?.error.');
    input?.displayError
        ?.tr(context)
        .toString()
        .debug('input?.displayError?.tr(context).');
    input?.isPure.toString().debug('input?.isPure.');
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${fieldEnum.name}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            fieldEnum,
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

  Widget _buildPasswordField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${fieldEnum.name}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            fieldEnum,
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

  Widget _buildConfirmPasswordField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${fieldEnum.name}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            fieldEnum,
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

  Widget _buildAgeField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${fieldEnum.name}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            fieldEnum,
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

  Widget _buildFirstNameField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${fieldEnum.name}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            fieldEnum,
            value,
          ),
      decoration: InputDecoration(
        labelText: 'First Name',
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildLastNameField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${fieldEnum.name}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            fieldEnum,
            value,
          ),
      decoration: InputDecoration(
        labelText: 'Last Name',
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateOfBirthField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${fieldEnum.name}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            fieldEnum,
            value,
          ),
      decoration: InputDecoration(
        labelText: 'Date of Birth (DD/MM/YYYY)',
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPhoneField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${fieldEnum.name}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            fieldEnum,
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

  Widget _buildAddressField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${fieldEnum.name}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            fieldEnum,
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

  Widget _buildNotificationChannelField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
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
                      fieldEnum,
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

  Widget _buildTermsField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<bool>?;
    final isChecked = input?.value ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          title: const Text('I accept the Terms and Conditions'),
          value: isChecked,
          onChanged: (value) {
            context.read<C>().updateInput<bool>(
                  fieldEnum,
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

  Widget _buildGenericTextField(
      BuildContext context, FormzBaseState state, FormFieldEnum fieldEnum) {
    final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
    return TextFormField(
      initialValue: input?.value,
      key: Key('mapBuilder_${fieldEnum.name}_textField'),
      onChanged: (value) => context.read<C>().updateInput<String>(
            fieldEnum,
            value,
          ),
      decoration: InputDecoration(
        labelText: _getFieldLabel(fieldEnum),
        errorText: input?.displayError?.tr(context),
        border: const OutlineInputBorder(),
      ),
    );
  }

  String _getFieldLabel(FormFieldEnum fieldEnum) {
    switch (fieldEnum) {
      case FormFieldEnum.email:
        return 'Email';
      case FormFieldEnum.password:
        return 'Password';
      case FormFieldEnum.confirmPassword:
        return 'Confirm Password';
      case FormFieldEnum.age:
        return 'Age';
      case FormFieldEnum.firstName:
        return 'First Name';
      case FormFieldEnum.lastName:
        return 'Last Name';
      case FormFieldEnum.dob:
        return 'Date of Birth';
      case FormFieldEnum.phone:
        return 'Phone';
      case FormFieldEnum.address:
        return 'Address';
      case FormFieldEnum.notificationChannel:
        return 'Notification Channel';
      case FormFieldEnum.termsAccepted:
        return 'Terms Accepted';
    }
  }
}
