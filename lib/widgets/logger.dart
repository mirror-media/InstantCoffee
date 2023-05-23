import 'package:flutter/foundation.dart';

mixin Logger {
  debugLog(obj) {
    if (kDebugMode) {
      print(obj);
    }
  }
}
