import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/debug_extension.dart';
import 'package:formz_example/form_field.dart';
import 'validators.dart';
import 'form_input_complex.dart';

class ComplexFormExample extends StatelessWidget {
  const ComplexFormExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complex Form Example'),
      ),
      body: BlocProvider(
        create: (_) => FormCubit(),
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
  int _currentSection = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepper(),
          const SizedBox(height: 16.0),
          Text(
            _formSections[_currentSection],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24.0),
          Expanded(
            child: SingleChildScrollView(
              child: _buildCurrentSection(),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      children: List.generate(
        _formSections.length * 2 - 1,
        (index) {
          if (index.isEven) {
            final stepIndex = index ~/ 2;
            final isActive = stepIndex <= _currentSection;
            final isCompleted = stepIndex < _currentSection;

            return Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isActive
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
                          color: isActive ? Colors.white : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          } else {
            return Expanded(
              child: Container(
                height: 2,
                color: index < _currentSection * 2
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCurrentSection() {
    switch (_currentSection) {
      case 0:
        return _PersonalInformationForm();
      case 1:
        return _ContactDetailsForm();
      case 2:
        return _PreferencesForm();
      default:
        return const SizedBox();
    }
  }

  Widget _buildNavigationButtons() {
    return BlocConsumer<FormCubit, FormzState>(
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
            if (_currentSection > 0)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentSection--;
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
            if (_currentSection < _formSections.length - 1)
              ElevatedButton(
                onPressed: _validateCurrentStep()
                    ? () {
                        setState(() {
                          _currentSection++;
                        });
                      }
                    : null,
                child: const Text('Next'),
              )
            else
              ElevatedButton(
                onPressed: _validateCurrentStep() && state.isAllValid
                    ? () => context.read<FormCubit>().submit()
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

  bool _validateCurrentStep() {
    final cubit = context.read<FormCubit>();
    final state = cubit.state;

    switch (_currentSection..debug('Room201')) {
      case 0:
        return _isPersonalInfoValid(state);
      case 1:
        return _isContactDetailsValid(state);
      case 2:
        return _isPreferencesValid(state);
      default:
        return false;
    }
  }

  bool _isPersonalInfoValid(FormzState state) {
    return state.step1.inputs[FormFieldEnum.firstName]?.isValid == true &&
        state.step1.inputs[FormFieldEnum.lastName]?.isValid == true &&
        state.step1.inputs[FormFieldEnum.dob]?.isValid == true;
  }

  bool _isContactDetailsValid(FormzState state) {
    return state.step2.inputs[FormFieldEnum.email]?.isValid == true &&
        state.step2.inputs[FormFieldEnum.phone]?.isValid == true;
  }

  bool _isPreferencesValid(FormzState state) {
    return state.step3.inputs[FormFieldEnum.notificationChannel]?.isValid ==
        true;
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

  Widget _buildFirstNameField() {
    return BlocBuilder<FormCubit, FormzState>(
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
          onChanged: (value) => context.read<FormCubit>().updateInput<String>(
            FormFieldEnum.firstName,
            value,
            [requiredValidator],
          ),
          decoration: InputDecoration(
            labelText: 'First Name',
            errorText: input?.displayError,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildLastNameField() {
    return BlocBuilder<FormCubit, FormzState>(
      // buildWhen: (previous, current) {
      //   final previousInput = previous.currentStep
      //       .inputs[FormFieldEnum.lastName] as GenericInput<String>?;
      //   final currentInput = current.currentStep.inputs[FormFieldEnum.lastName]
      //       as GenericInput<String>?;
      //   return previousInput?.value != currentInput?.value ||
      //       previousInput?.isPure != currentInput?.isPure;
      // },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.lastName]
            as GenericInput<String>?;
        return TextFormField(
          initialValue: input?.value,
          key: const Key('complexForm_lastName_textField'),
          onChanged: (value) => context.read<FormCubit>().updateInput<String>(
            FormFieldEnum.lastName,
            value,
            [requiredValidator],
          ),
          decoration: InputDecoration(
            labelText: 'Last Name',
            errorText: input?.displayError,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildDateOfBirthField() {
    return BlocBuilder<FormCubit, FormzState>(
      // buildWhen: (previous, current) {
      //   final previousInput = previous.currentStep.inputs[FormFieldEnum.dob]
      //       as GenericInput<String>?;
      //   final currentInput = current.currentStep.inputs[FormFieldEnum.dob]
      //       as GenericInput<String>?;
      //   return previousInput?.value != currentInput?.value ||
      //       previousInput?.isPure != currentInput?.isPure;
      // },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.dob]
            as GenericInput<String>?;
        return TextFormField(
          initialValue: input?.value,
          key: const Key('complexForm_dob_textField'),
          onChanged: (value) => context.read<FormCubit>().updateInput<String>(
            FormFieldEnum.dob,
            value,
            [
              requiredValidator,
              (value) {
                // Basic date validation (you might want to use a date picker instead)
                final datePattern = RegExp(r'^\d{2}/\d{2}/\d{4}$');
                if (!datePattern.hasMatch(value)) {
                  return 'Use format: DD/MM/YYYY';
                }
                return null;
              },
            ],
          ),
          decoration: InputDecoration(
            labelText: 'Date of Birth (DD/MM/YYYY)',
            errorText: input?.displayError,
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

  Widget _buildEmailField() {
    return BlocBuilder<FormCubit, FormzState>(
      // buildWhen: (previous, current) {
      //   final previousInput = previous.currentStep.inputs[FormFieldEnum.email]
      //       as GenericInput<String>?;
      //   final currentInput = current.currentStep.inputs[FormFieldEnum.email]
      //       as GenericInput<String>?;
      //   return previousInput?.value != currentInput?.value ||
      //       previousInput?.isPure != currentInput?.isPure;
      // },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.email]
            as GenericInput<String>?;
        return TextFormField(
          key: const Key('complexForm_email_textField'),
          initialValue: input?.value,
          onChanged: (value) => context.read<FormCubit>().updateInput<String>(
            FormFieldEnum.email,
            value,
            [requiredValidator, emailValidator],
          ),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: input?.displayError,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildPhoneField() {
    return BlocBuilder<FormCubit, FormzState>(
      // buildWhen: (previous, current) {
      //   final previousInput = previous.currentStep.inputs[FormFieldEnum.phone]
      //       as GenericInput<String>?;
      //   final currentInput = current.currentStep.inputs[FormFieldEnum.phone]
      //       as GenericInput<String>?;
      //   return previousInput?.value != currentInput?.value ||
      //       previousInput?.isPure != currentInput?.isPure;
      // },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.phone]
            as GenericInput<String>?;
        return TextFormField(
          initialValue: input?.value,
          key: const Key('complexForm_phone_textField'),
          onChanged: (value) => context.read<FormCubit>().updateInput<String>(
            FormFieldEnum.phone,
            value,
            [
              requiredValidator,
              (value) {
                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                  return 'Please enter a valid 10-digit phone number';
                }
                return null;
              },
            ],
          ),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone (10 digits)',
            errorText: input?.displayError,
            border: const OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildAddressField() {
    return BlocBuilder<FormCubit, FormzState>(
      // buildWhen: (previous, current) {
      //   final previousInput = previous.currentStep.inputs[FormFieldEnum.address]
      //       as GenericInput<String>?;
      //   final currentInput = current.currentStep.inputs[FormFieldEnum.address]
      //       as GenericInput<String>?;
      //   return previousInput?.value != currentInput?.value ||
      //       previousInput?.isPure != currentInput?.isPure;
      // },
      builder: (context, state) {
        final input = state.currentStep.inputs[FormFieldEnum.address]
            as GenericInput<String>?;
        return TextFormField(
          initialValue: input?.value,
          key: const Key('complexForm_address_textField'),
          onChanged: (value) => context.read<FormCubit>().updateInput<String>(
            FormFieldEnum.address,
            value,
            [], // Optional field, no validators
          ),
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Address (Optional)',
            errorText: input?.displayError,
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

  Widget _buildNotificationChannelField(BuildContext context) {
    return BlocBuilder<FormCubit, FormzState>(
      // buildWhen: (previous, current) {
      //   final previousInput = previous.currentStep
      //       .inputs[FormFieldEnum.notificationChannel] as GenericInput<String>?;
      //   final currentInput = current.currentStep
      //       .inputs[FormFieldEnum.notificationChannel] as GenericInput<String>?;
      //   return previousInput?.value != currentInput?.value ||
      //       previousInput?.isPure != currentInput?.isPure;
      // },
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
                    context.read<FormCubit>().updateInput<String>(
                      FormFieldEnum.notificationChannel,
                      value,
                      [requiredValidator],
                    );
                  }
                },
              );
            }),
            if (input?.displayError != null)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  input!.displayError!,
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

  Widget _buildTermsAndConditionsCheckbox() {
    return BlocBuilder<FormCubit, FormzState>(
      // buildWhen: (previous, current) {
      //   final previousInput = previous.currentStep
      //       .inputs[FormFieldEnum.termsAccepted] as GenericInput<bool>?;
      //   final currentInput = current.currentStep
      //       .inputs[FormFieldEnum.termsAccepted] as GenericInput<bool>?;
      //   return previousInput?.value != currentInput?.value ||
      //       previousInput?.isPure != currentInput?.isPure;
      // },
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
                context.read<FormCubit>().updateInput<bool>(
                  FormFieldEnum.termsAccepted,
                  value ?? false,
                  [
                    (value) => value != true
                        ? 'You must accept the terms and conditions'
                        : null,
                  ],
                );
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (input?.displayError != null)
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  input!.displayError!,
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
