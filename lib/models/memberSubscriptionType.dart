enum SubscritionType { none, marketing, monthly_subscriber, yearly_subscriber }

class MemberSubscritionType {
  List<String> subscriptionList;

  MemberSubscritionType({
    this.subscriptionList,
  });

  factory MemberSubscritionType.fromJson(Map<String, dynamic> json) {
    if(json == null) {
      return MemberSubscritionType(
        subscriptionList: null,
      );
    }

    return MemberSubscritionType(
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