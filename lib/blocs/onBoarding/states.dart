import 'package:readr_app/models/onBoarding.dart';
import 'package:readr_app/models/onBoardingHint.dart';

enum OnBoardingStatus { firstPage, secondPage, thirdPage, fourthPage, close }

List onBoardingHintList = [
  OnBoardingHint(
    page: 1,
    hintText: '新功能上線！來看看你的個人專屬頁面',
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
  final OnBoardingStatus status;
  final OnBoarding onBoarding;
  final OnBoardingHint onBoardingHint;

  const OnBoardingState({
    this.status,
    this.onBoarding,
    this.onBoardingHint,
  });

  OnBoardingState copyWith({
    OnBoardingStatus status,
    OnBoarding onBoarding,
  }) {
    return OnBoardingState(
      status: status,
      onBoarding: onBoarding,
      onBoardingHint: (status == null || status.index == 0)
          ? null
          : onBoardingHintList[status.index - 1],
    );
  }

  @override
  String toString() {
    return 'OnBoardingState { status: $status }';
  }
}
