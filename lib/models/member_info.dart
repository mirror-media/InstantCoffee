import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/member_subscription_type.dart';

part 'member_info.g.dart';

@JsonSerializable()
class MemberInfo {
  String? id;
  @JsonKey(name: 'state')
  MemberStateType? memberStateType;
  @JsonKey(name: 'type')
  SubscriptionType? subscriptionType;
  String? subscription;

  MemberInfo(
      {this.id,
      this.memberStateType,
      this.subscriptionType,
      this.subscription});

  factory MemberInfo.fromJson(Map<String, dynamic> json) {
    final obj = _$MemberInfoFromJson(json);

    return obj;
  }

  Map<String, dynamic> toJson() => _$MemberInfoToJson(this);

  bool get isPremiumMember =>
      subscriptionType != SubscriptionType.none &&
      subscriptionType != SubscriptionType.subscribe_one_time;
}
