import 'package:formz_example/shared/enum/input_error_enum.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';
import 'package:formz_example/shared/generic_inputs/generic_input/generic_input.dart';
import 'package:formz_example/shared/validators/validator_type.dart';

class VerticalSpace extends GenericAsyncInput<num> {
  VerticalSpace(num value)
      : super.pure(
          validators: [],
          value: value,
          isDisabled: false,
          uiType: UiTypeEnum.verticalSpace,
        );
  @override
  Future<Map<String, dynamic>> toJson() async {
    return {};
  }

  @override
  InputErrorEnum? validator(void value) {
    return null;
  }

  @override
  List<Validator<void>> get validators => [];

  @override
  String toString() {
    return 'VerticalSpace{$label}';
  }
}
