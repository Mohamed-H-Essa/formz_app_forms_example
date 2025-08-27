import 'package:flutter/widgets.dart';
import 'package:formz_example/shared/enum/ui_type_enum.dart';

extension ToInputTypeExtention on UiTypeEnum {
  TextInputType toInputType() {
    switch (this) {
      case UiTypeEnum.simpleTextField:
        return TextInputType.text;
      case UiTypeEnum.phone:
        return TextInputType.phone;
      case UiTypeEnum.number:
        return TextInputType.number;
      case UiTypeEnum.password:
        return TextInputType.visiblePassword;
      case UiTypeEnum.url:
        return TextInputType.url;
      // case UiTypeEnum.multiInput:
      //   return TextInputType.multiline;
      case UiTypeEnum.datePicker:
        return TextInputType.datetime;
      default:
        return TextInputType.text;
    }
  }
}
