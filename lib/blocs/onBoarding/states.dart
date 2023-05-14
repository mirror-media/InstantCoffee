import 'package:readr_app/models/on_boarding_position.dart';
import 'package:readr_app/models/on_boarding_hint.dart';

enum OnBoardingStatus { firstPage, secondPage, thirdPage, fourthPage }

List onBoardingHintList = [
  OnBoardingHint(
    page: 1,
    hintText: '新功能上線！\n來看看你的個人專屬頁面',
    left: -32,
    top: 16,
  ),
  OnBoardingHint(
    page: 2,
    hintText: '可新增或移除訂閱的文章類別',
    left: 0,
    top: 16,
  ),
  OnBoardingHint(
    page: 3,
    hintText: '最後設定想接收的推播類型',
    left: 64,
    top: 32,
  ),
  OnBoardingHint(
    page: 4,
    hintText: '開啟通知',
    left: 0,
    top: 16,
  )
];

class OnBoardingState {
  final bool isOnBoarding;
  final OnBoardingStatus? status;
  final OnBoardingPosition? onBoardingPosition;
  final OnBoardingHint? onBoardingHint;

  const OnBoardingState({
    this.isOnBoarding = false,
    this.status,
    this.onBoardingPosition,
    this.onBoardingHint,
  });

  OnBoardingState copyWith({
    required bool isOnBoarding,
    required OnBoardingStatus status,
    required OnBoardingPosition onBoardingPosition,
  }) {
    return OnBoardingState(
        isOnBoarding: isOnBoarding,
        status: status,
        onBoardingPosition: onBoardingPosition,
        onBoardingHint: onBoardingHintList[status.index]);
  }

  @override
  String toString() {
    return 'OnBoardingState { status: $status }';
  }
}
