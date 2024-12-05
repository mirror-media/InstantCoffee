// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAuthInfo _$UserAuthInfoFromJson(Map<String, dynamic> json) => UserAuthInfo(
  id: json['id'] as String?,
  subscriptionType:
  UserAuthInfo._subscriptionTypeFromJson(json['type'] as String?),
);

Map<String, dynamic> _$UserAuthInfoToJson(UserAuthInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type':
      UserAuthInfo._subscriptionTypeToJson(instance.subscriptionType),
    };