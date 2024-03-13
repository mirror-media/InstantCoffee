// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberInfo _$MemberInfoFromJson(Map<String, dynamic> json) => MemberInfo(
      id: json['id'] as String?,
      memberStateType:
          $enumDecodeNullable(_$MemberStateTypeEnumMap, json['state']),
      subscriptionType:
          $enumDecodeNullable(_$SubscriptionTypeEnumMap, json['type']),
      subscription: json['subscription'] as String?,
    );

Map<String, dynamic> _$MemberInfoToJson(MemberInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'state': _$MemberStateTypeEnumMap[instance.memberStateType],
      'type': _$SubscriptionTypeEnumMap[instance.subscriptionType],
      'subscription': instance.subscription,
    };

const _$MemberStateTypeEnumMap = {
  MemberStateType.active: 'active',
  MemberStateType.inactive: 'inactive',
};

const _$SubscriptionTypeEnumMap = {
  SubscriptionType.none: 'none',
  SubscriptionType.marketing: 'marketing',
  SubscriptionType.subscribe_one_time: 'subscribe_one_time',
  SubscriptionType.subscribe_monthly: 'subscribe_monthly',
  SubscriptionType.subscribe_yearly: 'subscribe_yearly',
  SubscriptionType.subscribe_group: 'subscribe_group',
  SubscriptionType.staff: 'staff',
};
