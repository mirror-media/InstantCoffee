import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class ErrorLogHelper {
  Future<void> record(dynamic exception, StackTrace? stack) async {
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      FirebaseCrashlytics.instance.recordError(exception, stack);
    }
  }
}
