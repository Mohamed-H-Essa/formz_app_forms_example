// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:formz/formz.dart';
// import 'package:formz_example/facility_registration/cubit/facility_registration_cubit.dart';
// import 'package:formz_example/shared/enum/form_field_enum.dart';
// import 'form_input_complex.dart';

// /// A simple form builder that automatically generates UI based on the form state
// class SimpleFormBuilder extends StatelessWidget {
//   const SimpleFormBuilder({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Simple Form Builder'),
//         backgroundColor: Colors.blue[600],
//         foregroundColor: Colors.white,
//       ),
//       body: BlocProvider(
//         create: (_) => FacilityRegistrationFormCubit(),
//         child: const _FormBuilderContent(),
//       ),
//     );
//   }
// }

// class _FormBuilderContent extends StatelessWidget {
//   const _FormBuilderContent({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<FormCubit, FormzState>(
//       listenWhen: (previous, current) => previous.status != current.status,
//       listener: (context, state) {
//         if (state.status == FormzSubmissionStatus.success) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               const SnackBar(
//                 content: Text('Form submitted successfully!'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//         } else if (state.status == FormzSubmissionStatus.failure) {
//           ScaffoldMessenger.of(context)
//             ..hideCurrentSnackBar()
//             ..showSnackBar(
//               const SnackBar(
//                 content:
//                     Text('Form submission failed. Please check your inputs.'),
//                 backgroundColor: Colors.red,
//               ),
//             );
//         }
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildStepIndicator(),
//             const SizedBox(height: 24),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: _buildFormFields(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildActionButtons(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStepIndicator() {
//     return BlocBuilder<FormCubit, FormzState>(
//       builder: (context, state) {
//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           decoration: BoxDecoration(
//             color: Colors.blue[50],
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.blue[200]!),
//           ),
//           child: Row(
//             children: [
//               Icon(Icons.info_outline, color: Colors.blue[600]),
//               const SizedBox(width: 8),
//               Text(
//                 'Step ${state.currentStepIndex} of 3',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue[800],
//                 ),
//               ),
//               const Spacer(),
//               if (state.currentStep.isValid)
//                 Icon(Icons.check_circle, color: Colors.green[600])
//               else
//                 Icon(Icons.pending, color: Colors.orange[600]),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildFormFields() {
//     return BlocBuilder<FormCubit, FormzState>(
//       builder: (context, state) {
//         final inputs = state.currentStep.inputs;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Text(
//               _getStepTitle(state.currentStepIndex),
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _getStepDescription(state.currentStepIndex),
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             const SizedBox(height: 24),
//             ...inputs.entries.map((entry) {
//               return Padding(
//                 padding: const EdgeInsets.only(bottom: 16.0),
//                 child: _buildFieldWidget(entry.key, entry.value),
//               );
//             }).toList(),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildFieldWidget(String field, FormzInput input) {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final prevInput = previous.currentStep.inputs[field];
//         final currInput = current.currentStep.inputs[field];
//         return prevInput?.value != currInput?.value ||
//             prevInput?.isPure != currInput?.isPure;
//       },
//       builder: (context, state) {
//         final currentInput = state.currentStep.inputs[field];
//         if (currentInput is GenericInput<String>) {
//           return _buildTextFormField(context, field, currentInput);
//         } else if (currentInput is GenericInput<bool>) {
//           return _buildBooleanField(context, field, currentInput);
//         }
//         return const SizedBox.shrink();
//       },
//     );
//   }

//   Widget _buildTextFormField(
//       BuildContext context, String field, GenericInput<String> input) {
//     final fieldConfig = _getFieldConfig(field);

//     return TextFormField(
//       initialValue: input.value,
//       onChanged: (value) =>
//           context.read<FormCubit>().updateInput<String>(field, value),
//       keyboardType: fieldConfig.keyboardType,
//       obscureText: fieldConfig.isPassword,
//       maxLines: fieldConfig.maxLines,
//       decoration: InputDecoration(
//         labelText: fieldConfig.label,
//         helperText: fieldConfig.helperText,
//         errorText: input.displayError,
//         prefixIcon: fieldConfig.icon != null ? Icon(fieldConfig.icon) : null,
//         border: const OutlineInputBorder(),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue[600]!),
//         ),
//         errorBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.red),
//         ),
//       ),
//     );
//   }

//   Widget _buildBooleanField(
//       BuildContext context, String field, GenericInput<bool> input) {
//     final fieldConfig = _getFieldConfig(field);

//     if (field == String.termsAccepted) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CheckboxListTile(
//             title: Text(fieldConfig.label),
//             value: input.value,
//             onChanged: (value) => context
//                 .read<FormCubit>()
//                 .updateInput<bool>(field, value ?? false),
//             controlAffinity: ListTileControlAffinity.leading,
//             contentPadding: EdgeInsets.zero,
//           ),
//           if (input.displayError != null)
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0),
//               child: Text(
//                 input.displayError!,
//                 style: const TextStyle(
//                   color: Colors.red,
//                   fontSize: 12.0,
//                 ),
//               ),
//             ),
//         ],
//       );
//     }

//     // Handle radio buttons for notification channel
//     if (field == String.notificationChannel) {
//       final options = ['Email', 'SMS', 'Push Notification', 'None'];
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             fieldConfig.label,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           ...options.map((option) {
//             return RadioListTile<String>(
//               title: Text(option),
//               value: option,
//               groupValue: (input as GenericInput<String>).value.isEmpty
//                   ? null
//                   : (input as GenericInput<String>).value,
//               onChanged: (value) {
//                 if (value != null) {
//                   context.read<FormCubit>().updateInput<String>(field, value);
//                 }
//               },
//               contentPadding: EdgeInsets.zero,
//             );
//           }).toList(),
//           if (input.displayError != null)
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0),
//               child: Text(
//                 (input as GenericInput<String>).displayError!,
//                 style: const TextStyle(
//                   color: Colors.red,
//                   fontSize: 12.0,
//                 ),
//               ),
//             ),
//         ],
//       );
//     }
//     return const SizedBox.shrink();
//   }

//   Widget _buildActionButtons() {
//     return BlocBuilder<FormCubit, FormzState>(
//       builder: (context, state) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             // Previous button
//             if (state.currentStepIndex > 1)
//               ElevatedButton.icon(
//                 onPressed: () => context.read<FormCubit>().previousStep(),
//                 icon: const Icon(Icons.arrow_back),
//                 label: const Text('Previous'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey[300],
//                   foregroundColor: Colors.black87,
//                 ),
//               )
//             else
//               const SizedBox(),

//             // Next/Submit button
//             if (state.currentStepIndex < 3)
//               ElevatedButton.icon(
//                 onPressed: state.currentStep.isValid
//                     ? () => context.read<FormCubit>().nextStep()
//                     : null,
//                 icon: const Icon(Icons.arrow_forward),
//                 label: const Text('Next'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[600],
//                   foregroundColor: Colors.white,
//                 ),
//               )
//             else
//               ElevatedButton.icon(
//                 onPressed: state.isAllValid
//                     ? () => context.read<FormCubit>().submit()
//                     : null,
//                 icon: state.status == FormzSubmissionStatus.inProgress
//                     ? const SizedBox(
//                         width: 16,
//                         height: 16,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       )
//                     : const Icon(Icons.send),
//                 label: const Text('Submit'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green[600],
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   String _getStepTitle(int stepIndex) {
//     switch (stepIndex) {
//       case 1:
//         return 'Personal Information';
//       case 2:
//         return 'Contact Details';
//       case 3:
//         return 'Preferences';
//       default:
//         return 'Form Step';
//     }
//   }

//   String _getStepDescription(int stepIndex) {
//     switch (stepIndex) {
//       case 1:
//         return 'Please provide your basic information and account details.';
//       case 2:
//         return 'How can we reach you? Add your contact information.';
//       case 3:
//         return 'Customize your preferences and accept our terms.';
//       default:
//         return 'Please fill out the form fields below.';
//     }
//   }

//   _FieldConfig _getFieldConfig(String field) {
//     switch (field) {
//       case String.email:
//         return _FieldConfig(
//           label: 'Email Address',
//           helperText: 'Enter a valid email address',
//           keyboardType: TextInputType.emailAddress,
//           icon: Icons.email,
//         );
//       case String.password:
//         return _FieldConfig(
//           label: 'Password',
//           helperText:
//               'Minimum 8 characters with numbers and special characters',
//           isPassword: true,
//           icon: Icons.lock,
//         );
//       case String.confirmPassword:
//         return _FieldConfig(
//           label: 'Confirm Password',
//           helperText: 'Re-enter your password',
//           isPassword: true,
//           icon: Icons.lock_outline,
//         );
//       case String.age:
//         return _FieldConfig(
//           label: 'Age',
//           helperText: 'Must be between 18 and 120',
//           keyboardType: TextInputType.number,
//           icon: Icons.cake,
//         );
//       case String.firstName:
//         return _FieldConfig(
//           label: 'First Name',
//           icon: Icons.person,
//         );
//       case String.lastName:
//         return _FieldConfig(
//           label: 'Last Name',
//           icon: Icons.person_outline,
//         );
//       case String.dob:
//         return _FieldConfig(
//           label: 'Date of Birth',
//           helperText: 'Format: DD/MM/YYYY',
//           icon: Icons.calendar_today,
//         );
//       case String.phone:
//         return _FieldConfig(
//           label: 'Phone Number',
//           helperText: 'Enter 10 digits',
//           keyboardType: TextInputType.phone,
//           icon: Icons.phone,
//         );
//       case String.address:
//         return _FieldConfig(
//           label: 'Address (Optional)',
//           helperText: 'Your complete address',
//           maxLines: 3,
//           icon: Icons.location_on,
//         );
//       case String.notificationChannel:
//         return _FieldConfig(
//           label: 'Preferred Notification Channel',
//           helperText: 'How would you like to receive notifications?',
//         );
//       case String.termsAccepted:
//         return _FieldConfig(
//           label: 'I accept the Terms and Conditions',
//         );
//     }
//   }
// }

// class _FieldConfig {
//   final String label;
//   final String? helperText;
//   final TextInputType keyboardType;
//   final bool isPassword;
//   final int maxLines;
//   final IconData? icon;

//   _FieldConfig({
//     required this.label,
//     this.helperText,
//     this.keyboardType = TextInputType.text,
//     this.isPassword = false,
//     this.maxLines = 1,
//     this.icon,
//   });
// }
