import 'package:formz_example/shared/enum/input_error_enum.dart';

typedef Validator<T> = InputErrorEnum? Function(T value);
