import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';

enum MemberStatus { loading, loaded, error }

class MemberState {
  final MemberStatus status;
  final bool? isLogin;
  final String? israfelId;
  final SubscriptionType? subscriptionType;
  final dynamic errorMessages;

  const MemberState({
    required this.status,
    this.isLogin,
    this.israfelId,
    this.subscriptionType,
    this.errorMessages,
  });

  factory MemberState.isNotLogin() {
    return const MemberState(
      status: MemberStatus.loaded,
      isLogin: false,
    );
  }

  factory MemberState.loading() {
    return const MemberState(status: MemberStatus.loading);
  }

  factory MemberState.loaded({
    required bool isLogin,
    required String? israfelId,
    required SubscriptionType? subscriptionType,
  }) {
    return MemberState(
      status: MemberStatus.loaded,
      isLogin: isLogin,
      israfelId: israfelId,
      subscriptionType: subscriptionType,
    );
  }

  factory MemberState.error({dynamic errorMessages}) {
    return MemberState(
      status: MemberStatus.error,
      isLogin: false,
      errorMessages: errorMessages,
    );
  }

  bool get isPremium {
    bool isActualPremiumMember = isLogin == true &&
        subscriptionType != SubscriptionType.none &&
        subscriptionType != SubscriptionType.subscribe_one_time;

    if (isActualPremiumMember) {
      return true;
    }

    try {
      final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();
      if (remoteConfigHelper.isFreePremium) {
        return true;
      }
    } catch (e) {
      // 如果 RemoteConfig 還未初始化或出現錯誤，使用原始邏輯
    }

    return false;
  }

  bool get shouldShowPremiumUI {
    return isLogin == true &&
        subscriptionType != SubscriptionType.none &&
        subscriptionType != SubscriptionType.subscribe_one_time;
  }
}
