import 'dart:developer';

import 'package:flutter/foundation.dart';

extension DebugPrint on dynamic {
  void debug([String? room]) {
    if (kDebugMode) {
      // ignore: avoid_print
      log('${room != null ? '$room ' : ''}:: ${toString()}');
    }
  }
}
