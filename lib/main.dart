import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
// import 'complex_form_example.dart';
import 'package:formz_example/facility_registration/pages/facility_registration_form.dart';
import 'package:formz_example/shared/enum/form_field_enum.dart';
import 'form_input_complex.dart';
import 'simple_form_example_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formz Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formz Examples'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () {},
                // onPressed: () {
                //   Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (_) => BlocProvider(
                //         create: (_) => FormCubit(),
                //         child: const FormScreen(),
                //       ),
                //     ),
                //   );
                // },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text('Basic Form Example'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ComplexFormExample(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                ),
                child: const Text('Multi-Step Complex Form'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => const SimpleFormBuilder(),
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                ),
                child: const Text('🚀 Simple Form Builder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class FormScreen extends StatelessWidget {
//   const FormScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dynamic Form Example'),
//       ),
//       body: BlocListener<FormCubit, FormzState>(
//         listenWhen: (previous, current) => previous.status != current.status,
//         listener: (context, state) {
//           if (state.status == FormzSubmissionStatus.success) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 const SnackBar(content: Text('Form submitted successfully!')),
//               );
//             // Reset form after successful submission
//             context.read<FormCubit>().reset();
//           } else if (state.status == FormzSubmissionStatus.failure) {
//             ScaffoldMessenger.of(context)
//               ..hideCurrentSnackBar()
//               ..showSnackBar(
//                 const SnackBar(
//                   content:
//                       Text('Form submission failed. Please check your inputs.'),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 16.0),
//                 _EmailInput(),
//                 const SizedBox(height: 16.0),
//                 _PasswordInput(),
//                 const SizedBox(height: 16.0),
//                 _ConfirmPasswordInput(),
//                 const SizedBox(height: 16.0),
//                 _AgeInput(),
//                 const SizedBox(height: 32.0),
//                 _SubmitButton(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _EmailInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
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
//           key: const Key('formScreen_emailInput_textField'),
//           onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//                 FormFieldEnum.email,
//                 value,
//               ),
//           // initialValue: ,
//           keyboardType: TextInputType.emailAddress,
//           decoration: InputDecoration(
//             labelText: 'Email',
//             helperText: 'A valid email address',
//             errorText: input?.displayError,
//             prefixIcon: const Icon(Icons.email),
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

// class _PasswordInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep
//             .inputs[FormFieldEnum.password] as GenericInput<String>?;
//         final currentInput = current.currentStep.inputs[FormFieldEnum.password]
//             as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep.inputs[FormFieldEnum.password]
//             as GenericInput<String>?;
//         return TextFormField(
//           key: const Key('formScreen_passwordInput_textField'),
//           onChanged: (value) {
//             context.read<FormCubit>().updateInput<String>(
//                   FormFieldEnum.password,
//                   value,
//                 );
//             // If confirm password field exists, validate it again against new password
//             final confirmPassword =
//                 state.currentStep.inputs[FormFieldEnum.confirmPassword];
//             if (confirmPassword != null) {
//               final confirmValue =
//                   (confirmPassword as GenericInput<String>).value;
//               context.read<FormCubit>().updateInput<String>(
//                     FormFieldEnum.confirmPassword,
//                     confirmValue,
//                   );
//             }
//           },
//           obscureText: true,
//           decoration: InputDecoration(
//             labelText: 'Password',
//             helperText: 'Min. 8 characters with numbers and special characters',
//             errorText: input?.displayError,
//             prefixIcon: const Icon(Icons.lock),
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

// class _ConfirmPasswordInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep
//             .inputs[FormFieldEnum.confirmPassword] as GenericInput<String>?;
//         final currentInput = current.currentStep
//             .inputs[FormFieldEnum.confirmPassword] as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep.inputs[FormFieldEnum.confirmPassword]
//             as GenericInput<String>?;

//         return TextFormField(
//           key: const Key('formScreen_confirmPasswordInput_textField'),
//           onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//                 FormFieldEnum.confirmPassword,
//                 value,
//               ),
//           obscureText: true,
//           decoration: InputDecoration(
//             labelText: 'Confirm Password',
//             helperText: 'Re-enter your password',
//             errorText: input?.displayError,
//             prefixIcon: const Icon(Icons.lock_outline),
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

// class _AgeInput extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) {
//         final previousInput = previous.currentStep.inputs[FormFieldEnum.age]
//             as GenericInput<String>?;
//         final currentInput = current.currentStep.inputs[FormFieldEnum.age]
//             as GenericInput<String>?;
//         return previousInput?.value != currentInput?.value ||
//             previousInput?.isPure != currentInput?.isPure;
//       },
//       builder: (context, state) {
//         final input = state.currentStep.inputs[FormFieldEnum.age]
//             as GenericInput<String>?;

//         return TextFormField(
//           key: const Key('formScreen_ageInput_textField'),
//           onChanged: (value) => context.read<FormCubit>().updateInput<String>(
//                 FormFieldEnum.age,
//                 value,
//               ),
//           keyboardType: TextInputType.number,
//           decoration: InputDecoration(
//             labelText: 'Age',
//             helperText: 'Must be between 18 and 120',
//             errorText: input?.displayError,
//             prefixIcon: const Icon(Icons.person),
//             border: const OutlineInputBorder(),
//           ),
//         );
//       },
//     );
//   }
// }

// class _SubmitButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FormCubit, FormzState>(
//       buildWhen: (previous, current) =>
//           previous.status != current.status ||
//           previous.isAllValid != current.isAllValid,
//       builder: (context, state) {
//         return ElevatedButton(
//           key: const Key('formScreen_submit_elevatedButton'),
//           onPressed: state.isAllValid
//               ? () => context.read<FormCubit>().submit()
//               : null,
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 16.0),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//           ),
//           child: state.status == FormzSubmissionStatus.inProgress
//               ? const SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2.0,
//                     color: Colors.white,
//                   ),
//                 )
//               : const Text(
//                   'SUBMIT',
//                   style: TextStyle(fontSize: 16.0),
//                 ),
//         );
//       },
//     );
//   }
// }
