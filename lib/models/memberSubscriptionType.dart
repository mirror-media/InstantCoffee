import 'package:readr_app/helpers/EnumParser.dart';

enum SubscritionType { 
  none, 
  marketing, 
  subscribe_one_time, 
  subscribe_monthly, 
  subscribe_yearly 
}

class MemberIdAndSubscritionType {
  final String israfelId;
  final SubscritionType subscritionType;

  MemberIdAndSubscritionType({
    this.israfelId,
    this.subscritionType,
  });

  factory MemberIdAndSubscritionType.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return MemberIdAndSubscritionType(
        israfelId: null,
        subscritionType: SubscritionType.none,
      );
    }

    String type = json['type'];
    SubscritionType subscritionType = type.toEnum(SubscritionType.values);

    return MemberIdAndSubscritionType(
      israfelId: json['id'],
      subscritionType: subscritionType,
    );
  }
}