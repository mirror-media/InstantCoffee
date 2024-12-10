import 'package:json_annotation/json_annotation.dart';
import 'package:readr_app/models/member_subscription_type.dart';

part 'user_auth_info.g.dart';

@JsonSerializable()
class UserAuthInfo extends Object {
  @JsonKey(name: 'id')
  String? id;



  @JsonKey(
    name: 'type',
    fromJson: _subscriptionTypeFromJson,
    toJson: _subscriptionTypeToJson,
  )
  SubscriptionType? subscriptionType;

  UserAuthInfo({this.id, this.subscriptionType});

  factory UserAuthInfo.fromJson(Map<String, dynamic> srcJson) {

   return  _$UserAuthInfoFromJson(srcJson);
  }

  Map<String, dynamic> toJson() => _$UserAuthInfoToJson(this);

  static SubscriptionType _subscriptionTypeFromJson(String? value) {
    if (value == null) return SubscriptionType.none;
    return SubscriptionType.values.firstWhere(
          (e) => e.toString().split('.').last == value,
      orElse: () => SubscriptionType.none,
    );
  }

  static String? _subscriptionTypeToJson(SubscriptionType? subscriptionType) {
    return subscriptionType?.toString().split('.').last;
  }
}