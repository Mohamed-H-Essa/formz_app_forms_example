import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:formz_example/shared/models/step_state.dart';

abstract class FormzBaseState<StepStateB extends FormzStepBaseState>
    extends Equatable {
  final List<StepStateB> steps;
  final int currentStepIndex;
  final FormzSubmissionStatus status;
  final List<int> erroneousSteps;
  const FormzBaseState({
    required this.steps,
    required this.currentStepIndex,
    required this.status,
    required this.erroneousSteps,
  });

  factory FormzBaseState.init() {
    throw UnimplementedError('Concrete class must implement init method!');
  }

  StepStateB get currentStep {
    return steps[currentStepIndex];
  }

  bool get isAllValid {
    // return true;
    return !steps.any((step) => step.isNotValid);
    // if (step1.isValid && step2.isValid && step3.isValid) {
    //   return true;
    // } else {
    //   return false;
    // }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    for (int i = 0; i < steps.length; i++) {
      result.addAll({steps[i].stepId: steps[i].toJson()});
    }
    return result;
  }

  FormzBaseState copyWith({
    StepStateB? currentStep,
    List<StepStateB>? steps,
    int? currentStepIndex,
    FormzSubmissionStatus? status,
    List<int>? erroneousSteps,
  });
  //  {
  //   return FormzState(
  //     steps: steps ??
  //         (currentStep == null
  //             ? this.steps
  //             : (List<FormzStepState>.from(this.steps)
  //               ..[this.currentStepIndex - 1] = currentStep)),
  //     currentStepIndex: currentStepIndex ?? this.currentStepIndex,
  //     status: status ?? this.status,
  //     erroneousSteps: erroneousSteps ?? this.erroneousSteps,
  //   );
  // }

  @override
  List<Object?> get props => [steps, currentStepIndex, status, erroneousSteps];

  bool isErroneous(int index) {
    return erroneousSteps.contains(index);
  }

  @override
  String toString() {
    return 'FormzState{steps=$steps, currentStepIndex=$currentStepIndex, status=$status}';
  }
}
