enum SubscritionType { none, marketing, monthly_subscriber, yearly_subscriber }

class MemberIdAndSubscritionType {
  final String israfelId;
  final SubscritionType subscritionType;

  MemberIdAndSubscritionType({
    this.israfelId,
    this.subscritionType,
  });
}

class MemberSubscritionType {
  final String israfelId;
  List<String> subscriptionList;

  MemberSubscritionType({
    this.israfelId,
    this.subscriptionList,
  });

  factory MemberSubscritionType.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return MemberSubscritionType(
        israfelId: null,
        subscriptionList: null,
      );
    }

    return MemberSubscritionType(
      israfelId: json['id'],
      subscriptionList: parseSubscriptionList(json['subscription']),
    );
  }
}

List<String> parseSubscriptionList(List<dynamic>responseBody) {
  if(responseBody == null) return null;

  List<String> resultList = [];
  responseBody.forEach((element) { resultList.add(element['frequency']); });
  return resultList;
}