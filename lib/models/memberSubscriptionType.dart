import 'package:readr_app/helpers/EnumParser.dart';

enum SubscritionType { 
  none, 
  marketing, 
  subscribe_one_time, 
  subscribe_monthly, 
  subscribe_yearly,
  subscribe_group,
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
  final bool isNewebpay;

  MemberIdAndSubscritionType({
    this.israfelId,
    this.state,
    this.subscritionType,
    this.isNewebpay,
  });

  factory MemberIdAndSubscritionType.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return MemberIdAndSubscritionType(
        israfelId: null,
        state: null,
        subscritionType: SubscritionType.none,
        isNewebpay: false,
      );
    }

    String type = json['type'];
    SubscritionType subscritionType = type.toEnum(SubscritionType.values);

    String state = json['state'];
    MemberStateType memberStateType = state.toEnum(MemberStateType.values);

    bool isNewebpay = false;
    if(json['subscription'] != null && json['subscription'][0]['newebpayPayment']!=null){
      isNewebpay = true;
    }

    return MemberIdAndSubscritionType(
      israfelId: json['id'],
      state: memberStateType,
      subscritionType: subscritionType,
      isNewebpay: isNewebpay,
    );
  }
}