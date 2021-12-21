import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/models/onBoarding.dart';

abstract class OnBoardingEvents{}

class CheckOnBoarding extends OnBoardingEvents {
  CheckOnBoarding();

  @override
  String toString() => 'CheckOnBoarding';
}

class GoToNextHint extends OnBoardingEvents {
  final OnBoardingStatus onBoardingStatus;
  final OnBoarding onBoarding;
  GoToNextHint({
    this.onBoardingStatus,
    this.onBoarding,
  });

  @override
  String toString() => 'GoToNextHint { onBoardingStatus: $onBoardingStatus }';
}