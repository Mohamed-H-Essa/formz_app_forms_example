// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';
// import 'package:formz_example/debug_extension.dart';
// import 'package:formz_example/shared/enum/form_field_enum.dart';
// import 'form_input_complex.dart';

// class ComplexFormExample extends StatelessWidget {
//   const ComplexFormExample({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Complex Form Example'),
//       ),
//       body: BlocProvider(
//         create: (_) => FormCubit(),
//         child: const _ComplexFormContent(),
//       ),
//     );
//   }
// }

// class _ComplexFormContent extends StatefulWidget {
//   const _ComplexFormContent({Key? key}) : super(key: key);

//   @override
//   State<_ComplexFormContent> createState() => _ComplexFormContentState();
// }

// class _ComplexFormContentState extends State<_ComplexFormContent> {
//   final _formSections = [
//     'Personal Information',
//     'Contact Details',
//     'Preferences',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: BlocBuilder<FormCubit, FormzState>(
//         builder: (context, state) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildStepper(),
//               const SizedBox(height: 16.0),
//               Text(
//                 _formSections[state.currentStepIndex - 1],
//                 style: Theme.of(context).textTheme.headlineSmall,
//               ),
//               const SizedBox(height: 24.0),
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: _buildCurrentSection(),
//                 ),
//               ),
//               const SizedBox(height: 16.0),
//               _buildNavigationButtons(),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStepper() {
//     return BlocBuilder<FormCubit, FormzState>(
//       builder: (context, state) {
//         return Row(
//           children: List.generate(
//             _formSections.length * 2 - 1,
//             (index) {
//               if (index.isEven) {
//                 final stepIndex = index ~/ 2;
//                 final isActive = stepIndex <= state.currentStepIndex - 1;
//                 final isCompleted = stepIndex < state.currentStepIndex - 1;

//                 return Container(
//                   width: 30,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     color: state.isErroneous(stepIndex + 1)
//                         ? Colors.deepOrange
//                         : isActive
//                             ? Theme.of(context).primaryColor
//                             : Colors.grey.shade300,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: isCompleted
//                         ? const Icon(Icons.check, color: Colors.white, size: 16)
//                         : Text(
//                             '${stepIndex + 1}',
//                             style: TextStyle(
//                               color: isActive
//                                   ? Colors.white
//                                   : Colors.grey.shade600,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                   ),
//                 );
//               } else {
//                 return Expanded(
//                   child: Container(
//                     height: 2,
//                     color: index < (state.currentStepIndex - 1) * 2
//                         ? Theme.of(context).primaryColor
//                         : Colors.grey.shade300,
//                   ),
//                 );
//               }
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildCurrentSection() {
//     return BlocBuilder<FormCubit, FormzState>(builder: (_, __) {
//       return MapBuilder(formMap: __.currentStep.inputs);
//       switch (__.currentStepIndex) {
//         case 1:
//           // return Container();
//           return MapBuilder(formMap: __.currentStep.inputs);
//           return _PersonalInformationForm();
//         case 2:
//           return MapBuilder(formMap: __.currentStep.inputs);
//           return _ContactDetailsForm();
//         case 3:
//           return MapBuilder(formMap: __.currentStep.inputs);
//           return _PreferencesForm();
//         default:
//           return const SizedBox();
//       }
//     });
//   }

//   Widget _buildNavigationButtons() {
//     return BlocConsumer<FormCubit, FormzState>(
//       listenWhen: (previous, current) => previous.status != current.status,
//       listener: (context, state) {
//         if (state.status == FormzSubmissionStatus.success) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Form submitted successfully!')),
//           );
//           Navigator.of(context).pop();
//         }
//       },
//       builder: (context, state) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             if ((state.currentStepIndex - 1) > 0)
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     context.read<FormCubit>().previousStep();
//                   });
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey.shade200,
//                   foregroundColor: Colors.black87,
//                 ),
//                 child: const Text('Previous'),
//               )
//             else
//               const SizedBox(),
//             if ((state.currentStepIndex - 1) < _formSections.length - 1)
//               ElevatedButton(
//                 onPressed: _validateCurrentStep()
//                     ? () {
//                         setState(() {
//                           context.read<FormCubit>().nextStep();
//                         });
//                       }
//                     : null,
//                 child: const Text('Next'),
//               )
//             else
//               ElevatedButton(
//                 onPressed: _validateCurrentStep() && state.isAllValid
//                     ? () => context.read<FormCubit>().submit()
//                     : null,
//                 child: state.status == FormzSubmissionStatus.inProgress
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2.0,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Text('Submit'),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   bool _validateCurrentStep() {
//     final cubit = context.read<FormCubit>();
//     final state = cubit.state;

//     switch (state.currentStepIndex) {
//       case 1:
//         return state.isPersonalInfoValid(state);
//       case 2:
//         return state.isContactDetailsValid(state);
//       case 3:
//         return state.isPreferencesValid(state);
//       default:
//         return false;
//     }
//   }
// }

// class _PersonalInformationForm extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         _buildFirstNameField(),
//         const SizedBox(height: 16.0),
//         _buildLastNameField(),
//         const SizedBox(height: 16.0),
//         _buildDateOfBirthField(),
//       ],
//     );
//   }

//   Widget _buildFirstNameField() {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep
//             .inputs[FormFieldEnum.firstName] as GenericInput<String>?;
//         final currentInput = current.currentStep.inputs[FormFieldEnum.firstName]
//             as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep.inputs[FormFieldEnum.firstName]
//             as GenericInput<String>?;
//         return TextFormField(
//           initialValue: input?.value,
//           key: const Key('complexForm_firstName_textField'),
//           onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//                 FormFieldEnum.firstName,
//                 value,
//               ),
//           decoration: InputDecoration(
//             labelText: 'First Name',
//             errorText: input?.displayError,
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildLastNameField() {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep
//             .inputs[FormFieldEnum.lastName] as GenericInput<String>?;
//         final currentInput = current.currentStep.inputs[FormFieldEnum.lastName]
//             as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep.inputs[FormFieldEnum.lastName]
//             as GenericInput<String>?;
//         return TextFormField(
//           initialValue: input?.value,
//           key: const Key('complexForm_lastName_textField'),
//           onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//                 FormFieldEnum.lastName,
//                 value,
//               ),
//           decoration: InputDecoration(
//             labelText: 'Last Name',
//             errorText: input?.displayError,
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDateOfBirthField() {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep.inputs[FormFieldEnum.dob]
//             as GenericInput<String>?;
//         final currentInput = current.currentStep.inputs[FormFieldEnum.dob]
//             as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep.inputs[FormFieldEnum.dob]
//             as GenericInput<String>?;
//         return TextFormField(
//           initialValue: input?.value,
//           key: const Key('complexForm_dob_textField'),
//           onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//                 FormFieldEnum.dob,
//                 value,
//               ),
//           decoration: InputDecoration(
//             labelText: 'Date of Birth (DD/MM/YYYY)',
//             errorText: input?.displayError,
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

// class _ContactDetailsForm extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         _buildEmailField(),
//         const SizedBox(height: 16.0),
//         _buildPhoneField(),
//         const SizedBox(height: 16.0),
//         _buildAddressField(),
//       ],
//     );
//   }

//   Widget _buildEmailField() {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep.inputs[FormFieldEnum.email]
//             as GenericInput<String>?;
//         final currentInput = current.currentStep.inputs[FormFieldEnum.email]
//             as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep.inputs[FormFieldEnum.email]
//             as GenericInput<String>?;
//         return TextFormField(
//           key: const Key('complexForm_email_textField'),
//           initialValue: input?.value,
//           onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//                 FormFieldEnum.email,
//                 value,
//               ),
//           keyboardType: TextInputType.emailAddress,
//           decoration: InputDecoration(
//             labelText: 'Email',
//             errorText: input?.displayError,
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPhoneField() {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep.inputs[FormFieldEnum.phone]
//             as GenericInput<String>?;
//         final currentInput = current.currentStep.inputs[FormFieldEnum.phone]
//             as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep.inputs[FormFieldEnum.phone]
//             as GenericInput<String>?;
//         return TextFormField(
//           initialValue: input?.value,
//           key: const Key('complexForm_phone_textField'),
//           onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//                 FormFieldEnum.phone,
//                 value,
//               ),
//           keyboardType: TextInputType.phone,
//           decoration: InputDecoration(
//             labelText: 'Phone (10 digits)',
//             errorText: input?.displayError,
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAddressField() {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep.inputs[FormFieldEnum.address]
//             as GenericInput<String>?;
//         final currentInput = current.currentStep.inputs[FormFieldEnum.address]
//             as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep.inputs[FormFieldEnum.address]
//             as GenericInput<String>?;
//         return TextFormField(
//           initialValue: input?.value,
//           key: const Key('complexForm_address_textField'),
//           onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//                 FormFieldEnum.address,
//                 value,
//               ),
//           maxLines: 3,
//           decoration: InputDecoration(
//             labelText: 'Address (Optional)',
//             errorText: input?.displayError,
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

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

//   Widget _buildNotificationChannelField(BuildContext context) {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep
//             .inputs[FormFieldEnum.notificationChannel] as GenericInput<String>?;
//         final currentInput = current.currentStep
//             .inputs[FormFieldEnum.notificationChannel] as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep
//             .inputs[FormFieldEnum.notificationChannel] as GenericInput<String>?;
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
//                     context.read<FormCubit>().updateInput<String>(
//                           FormFieldEnum.notificationChannel,
//                           value..debug('UI clicked: '),
//                         );
//                   }
//                 },
//               );
//             }),
//             if (input?.displayError != null)
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0),
//                 child: Text(
//                   input!.displayError!,
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

//   Widget _buildTermsAndConditionsCheckbox() {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep
//             .inputs[FormFieldEnum.termsAccepted] as GenericInput<bool>?;
//         final currentInput = current.currentStep
//             .inputs[FormFieldEnum.termsAccepted] as GenericInput<bool>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep.inputs[FormFieldEnum.termsAccepted]
//             as GenericInput<bool>?;
//         final isChecked = input?.value ?? false;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CheckboxListTile(
//               title: const Text('I accept the Terms and Conditions'),
//               value: isChecked,
//               onChanged: (value) {
//                 context.read<FormCubit>().updateInput<bool>(
//                       FormFieldEnum.termsAccepted,
//                       value ?? false,
//                     );
//               },
//               controlAffinity: ListTileControlAffinity.leading,
//             ),
//             if (input?.displayError != null)
//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0),
//                 child: Text(
//                   input!.displayError!,
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

// // Dynamic form builder that creates widgets based on form field types
// class MapBuilder extends StatelessWidget {
//   const MapBuilder({
//     super.key,
//     required this.formMap,
//   });
//   final Map<FormFieldEnum, FormzInput> formMap;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         // Rebuild when any input in the form map changes
//         for (final fieldEnum in formMap.keys) {
//           final previousInput = previous.currentStep.inputs[fieldEnum];
//           final currentInput = current.currentStep.inputs[fieldEnum];

//           if (previousInput?.value != currentInput?.value ||
//               previousInput?.isPure != currentInput?.isPure) {
//             return true;
//           }
//         }
//         return false;
//       },
//       builder: (context, state) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: formMap.entries.map((entry) {
//             final fieldEnum = entry.key;
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: _buildFieldWidget(context, state, fieldEnum),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   Widget _buildFieldWidget(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     switch (fieldEnum) {
//       case FormFieldEnum.email:
//         return _buildEmailField(context, state, fieldEnum);
//       case FormFieldEnum.password:
//         return _buildPasswordField(context, state, fieldEnum);
//       case FormFieldEnum.confirmPassword:
//         return _buildConfirmPasswordField(context, state, fieldEnum);
//       case FormFieldEnum.age:
//         return _buildAgeField(context, state, fieldEnum);
//       case FormFieldEnum.firstName:
//         return _buildFirstNameField(context, state, fieldEnum);
//       case FormFieldEnum.lastName:
//         return _buildLastNameField(context, state, fieldEnum);
//       case FormFieldEnum.dob:
//         return _buildDateOfBirthField(context, state, fieldEnum);
//       case FormFieldEnum.phone:
//         return _buildPhoneField(context, state, fieldEnum);
//       case FormFieldEnum.address:
//         return _buildAddressField(context, state, fieldEnum);
//       case FormFieldEnum.notificationChannel:
//         return _buildNotificationChannelField(context, state, fieldEnum);
//       case FormFieldEnum.termsAccepted:
//         return _buildTermsField(context, state, fieldEnum);
//       default:
//         return _buildGenericTextField(context, state, fieldEnum);
//     }
//   }

//   Widget _buildEmailField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     return TextFormField(
//       initialValue: input?.value,
//       key: Key('mapBuilder_${fieldEnum.name}_textField'),
//       onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//             fieldEnum,
//             value,
//           ),
//       keyboardType: TextInputType.emailAddress,
//       decoration: InputDecoration(
//         labelText: 'Email',
//         errorText: input?.displayError,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildPasswordField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     return TextFormField(
//       initialValue: input?.value,
//       key: Key('mapBuilder_${fieldEnum.name}_textField'),
//       onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//             fieldEnum,
//             value,
//           ),
//       obscureText: true,
//       decoration: InputDecoration(
//         labelText: 'Password',
//         errorText: input?.displayError,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildConfirmPasswordField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     return TextFormField(
//       initialValue: input?.value,
//       key: Key('mapBuilder_${fieldEnum.name}_textField'),
//       onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//             fieldEnum,
//             value,
//           ),
//       obscureText: true,
//       decoration: InputDecoration(
//         labelText: 'Confirm Password',
//         errorText: input?.displayError,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildAgeField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     return TextFormField(
//       initialValue: input?.value,
//       key: Key('mapBuilder_${fieldEnum.name}_textField'),
//       onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//             fieldEnum,
//             value,
//           ),
//       keyboardType: TextInputType.number,
//       decoration: InputDecoration(
//         labelText: 'Age',
//         helperText: 'Must be between 18 and 120',
//         errorText: input?.displayError,
//         prefixIcon: const Icon(Icons.person),
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildFirstNameField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     return TextFormField(
//       initialValue: input?.value,
//       key: Key('mapBuilder_${fieldEnum.name}_textField'),
//       onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//             fieldEnum,
//             value,
//           ),
//       decoration: InputDecoration(
//         labelText: 'First Name',
//         errorText: input?.displayError,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildLastNameField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     return TextFormField(
//       initialValue: input?.value,
//       key: Key('mapBuilder_${fieldEnum.name}_textField'),
//       onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//             fieldEnum,
//             value,
//           ),
//       decoration: InputDecoration(
//         labelText: 'Last Name',
//         errorText: input?.displayError,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildDateOfBirthField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     return TextFormField(
//       initialValue: input?.value,
//       key: Key('mapBuilder_${fieldEnum.name}_textField'),
//       onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//             fieldEnum,
//             value,
//           ),
//       decoration: InputDecoration(
//         labelText: 'Date of Birth (DD/MM/YYYY)',
//         errorText: input?.displayError,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildPhoneField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     return TextFormField(
//       initialValue: input?.value,
//       key: Key('mapBuilder_${fieldEnum.name}_textField'),
//       onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//             fieldEnum,
//             value,
//           ),
//       keyboardType: TextInputType.phone,
//       decoration: InputDecoration(
//         labelText: 'Phone (10 digits)',
//         errorText: input?.displayError,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildAddressField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     return TextFormField(
//       initialValue: input?.value,
//       key: Key('mapBuilder_${fieldEnum.name}_textField'),
//       onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//             fieldEnum,
//             value,
//           ),
//       maxLines: 3,
//       decoration: InputDecoration(
//         labelText: 'Address (Optional)',
//         errorText: input?.displayError,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   Widget _buildNotificationChannelField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     final notificationOptions = ['Email', 'SMS', 'Push Notification', 'None'];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Preferred Notification Channel',
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//         const SizedBox(height: 8.0),
//         ...List.generate(notificationOptions.length, (index) {
//           final option = notificationOptions[index];
//           return RadioListTile<String>(
//             title: Text(option),
//             value: option,
//             groupValue: input?.value,
//             onChanged: (value) {
//               if (value != null) {
//                 context.read<FormCubit>().updateInput<String>(
//                       fieldEnum,
//                       value,
//                     );
//               }
//             },
//           );
//         }),
//         if (input?.displayError != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: Text(
//               input!.displayError!,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.error,
//                 fontSize: 12.0,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildTermsField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<bool>?;
//     final isChecked = input?.value ?? false;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CheckboxListTile(
//           title: const Text('I accept the Terms and Conditions'),
//           value: isChecked,
//           onChanged: (value) {
//             context.read<FormCubit>().updateInput<bool>(
//                   fieldEnum,
//                   value ?? false,
//                 );
//           },
//           controlAffinity: ListTileControlAffinity.leading,
//         ),
//         if (input?.displayError != null)
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: Text(
//               input!.displayError!,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.error,
//                 fontSize: 12.0,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildGenericTextField(
//       BuildContext context, FormzState state, FormFieldEnum fieldEnum) {
//     final input = state.currentStep.inputs[fieldEnum] as GenericInput<String>?;
//     return TextFormField(
//       initialValue: input?.value,
//       key: Key('mapBuilder_${fieldEnum.name}_textField'),
//       onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//             fieldEnum,
//             value,
//           ),
//       decoration: InputDecoration(
//         labelText: _getFieldLabel(fieldEnum),
//         errorText: input?.displayError,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }

//   String _getFieldLabel(FormFieldEnum fieldEnum) {
//     switch (fieldEnum) {
//       case FormFieldEnum.email:
//         return 'Email';
//       case FormFieldEnum.password:
//         return 'Password';
//       case FormFieldEnum.confirmPassword:
//         return 'Confirm Password';
//       case FormFieldEnum.age:
//         return 'Age';
//       case FormFieldEnum.firstName:
//         return 'First Name';
//       case FormFieldEnum.lastName:
//         return 'Last Name';
//       case FormFieldEnum.dob:
//         return 'Date of Birth';
//       case FormFieldEnum.phone:
//         return 'Phone';
//       case FormFieldEnum.address:
//         return 'Address';
//       case FormFieldEnum.notificationChannel:
//         return 'Notification Channel';
//       case FormFieldEnum.termsAccepted:
//         return 'Terms Accepted';
//     }
//   }
// }
