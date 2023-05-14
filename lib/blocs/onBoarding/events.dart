import 'package:readr_app/blocs/onBoarding/states.dart';
import 'package:readr_app/models/on_boarding_position.dart';

abstract class OnBoardingEvents {}

class CheckOnBoarding extends OnBoardingEvents {
  CheckOnBoarding();

  @override
  String toString() => 'CheckOnBoarding';
}

class GoToNextHint extends OnBoardingEvents {
  final OnBoardingStatus onBoardingStatus;
  final OnBoardingPosition onBoardingPosition;
  GoToNextHint({
    required this.onBoardingStatus,
    required this.onBoardingPosition,
  });

  @override
  String toString() => 'GoToNextHint { onBoardingStatus: $onBoardingStatus }';
}

class CloseOnBoarding extends OnBoardingEvents {
  CloseOnBoarding();

  @override
  String toString() => 'CloseOnBoarding';
}
