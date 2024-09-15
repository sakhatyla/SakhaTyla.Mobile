import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> reportError(
  dynamic error,
  dynamic stackTrace, {
  dynamic reason,
}) async {
  await FirebaseCrashlytics.instance
      .recordError(error, stackTrace, reason: reason);
}
