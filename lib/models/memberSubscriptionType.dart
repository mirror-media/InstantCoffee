import 'package:readr_app/helpers/EnumParser.dart';

enum SubscritionType { 
  none, 
  marketing, 
  subscribe_one_time, 
  subscribe_monthly, 
  subscribe_yearly,
  staff
}

enum MemberStateType { 
  active, 
  inactive
}

class MemberIdAndSubscritionType {
  final String israfelId;
  final MemberStateType state;
  SubscritionType subscritionType;

  MemberIdAndSubscritionType({
    this.israfelId,
    this.state,
    this.subscritionType,
  });

  factory MemberIdAndSubscritionType.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return MemberIdAndSubscritionType(
        israfelId: null,
        state: null,
        subscritionType: SubscritionType.none,
      );
    }

    String type = json['type'];
    SubscritionType subscritionType = type.toEnum(SubscritionType.values);

    String state = json['state'];
    MemberStateType memberStateType = state.toEnum(MemberStateType.values);

    return MemberIdAndSubscritionType(
      israfelId: json['id'],
      state: memberStateType,
      subscritionType: subscritionType,
    );
  }
}