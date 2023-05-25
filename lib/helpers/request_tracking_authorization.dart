import 'package:app_tracking_transparency/app_tracking_transparency.dart';

// ref: https://github.com/deniza/app_tracking_transparency/issues/32#issuecomment-1373148405
Future<void> requestTrackingAuthorizationOnIOS() async {
  TrackingStatus authorizationStatus =
      await AppTrackingTransparency.requestTrackingAuthorization();
  const retryThreshold = 10;
  int retryCount = 0;

  while (authorizationStatus == TrackingStatus.notDetermined &&
      retryCount < retryThreshold) {
    authorizationStatus =
        await AppTrackingTransparency.requestTrackingAuthorization();
    await Future.delayed(const Duration(milliseconds: 200));
    retryCount += 1;
  }
}
