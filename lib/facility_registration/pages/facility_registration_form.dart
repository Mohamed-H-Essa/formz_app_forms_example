import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/debug_extension.dart';
import 'package:formz_example/facility_registration/cubit/facility_registration_state.dart';
import 'package:formz_example/shared/cubits/base_form_cubit.dart';
import 'package:formz_example/shared/models/formz_state.dart';
import 'package:formz_example/shared/presentation/map_builder.dart';
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
      return MapBuilder<C>(formMap: __.currentStep.inputs);
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

// class _PreferencesForm extends StatelessWidget {
//   final List<String> _notificationOptions = [
//     'Email',
//     'SMS',
//     'Push Notification',
//     'None'
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         _buildNotificationChannelField(context),
//         const SizedBox(height: 16.0),
//         _buildTermsAndConditionsCheckbox(),
//       ],
//     );
//   }

//   Widget _buildNotificationChannelField<C extends FormCubitBase>(
//       BuildContext context) {
//     return BlocBuilder<C, FormzBaseState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous
//                 .currentStep.inputs[RegistrationInputKeys.notificationChannel]
//             as GenericInput<String>?;
//         final currentInput = current
//                 .currentStep.inputs[RegistrationInputKeys.notificationChannel]
//             as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input =
//             state.currentStep.inputs[RegistrationInputKeys.notificationChannel]
//                 as GenericInput<String>?;
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Preferred Notification Channel',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8.0),
//             ...List.generate(_notificationOptions.length, (index) {
//               final option = _notificationOptions[index];
//               return RadioListTile<String>(
//                 title: Text(option),
//                 value: option,
//                 groupValue: input?.value,
//                 onChanged: (value) {
//                   if (value != null) {
//                     'ui clicked'.debug();
//                     context.read<C>().updateInput<String>(
//                           RegistrationInputKeys.notificationChannel,
//                           value..debug('UI clicked: '),
//                         );
//                   }
//                 },
//               );
//             }),
//             if (input?.displayError?.tr(context) != null)
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0),
//                 child: Text(
//                   input!.displayError!.tr(context),
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.error,
//                     fontSize: 12.0,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTermsAndConditionsCheckbox<C extends FormCubitBase>() {
//     return BlocBuilder<C, FormzBaseState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep
//             .inputs[RegistrationInputKeys.termsAccepted] as GenericInput<bool>?;
//         final currentInput = current.currentStep
//             .inputs[RegistrationInputKeys.termsAccepted] as GenericInput<bool>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep
//             .inputs[RegistrationInputKeys.termsAccepted] as GenericInput<bool>?;
//         final isChecked = input?.value ?? false;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CheckboxListTile(
//               title: const Text('I accept the Terms and Conditions'),
//               value: isChecked,
//               onChanged: (value) {
//                 context.read<C>().updateInput<bool>(
//                       RegistrationInputKeys.termsAccepted,
//                       value ?? false,
//                     );
//               },
//               controlAffinity: ListTileControlAffinity.leading,
//             ),
//             if (input?.displayError?.tr(context) != null)
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0),
//                 child: Text(
//                   input!.displayError!.tr(context),
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.error,
//                     fontSize: 12.0,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }

// Dynamic form builder that creates widgets based on form field types
