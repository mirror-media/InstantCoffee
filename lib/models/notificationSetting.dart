class NotificationSetting {
  final String type;
  final String id;
  final String title;
  final String? topic;
  bool value;
  final List<NotificationSetting>? notificationSettingList;

  NotificationSetting({
    required this.type,
    required this.id,
    required this.title,
    required this.topic,
    required this.value,
    this.notificationSettingList,
  });

  factory NotificationSetting.fromJson(Map<String, dynamic> json) {
    return NotificationSetting(
      type: json['type'],
      id: json['id'],
      title: json['title'],
      topic: json['topic'],
      value: json['value'],
      notificationSettingList: json['notificationSettingList'] == null
      ? null
      : NotificationSetting.notificationSettingListFromJson(json['notificationSettingList']),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'title': title,
        'topic': topic,
        'value': value,
        'notificationSettingList': notificationSettingList == null
        ? null
        : NotificationSetting.toNotificationSettingListJson(notificationSettingList!),
      };

  static List<NotificationSetting> notificationSettingListFromJson(List<dynamic> jsonList) {
    return jsonList.map<NotificationSetting>((json) => NotificationSetting.fromJson(json)).toList();
  }

  static List<Map<dynamic, dynamic>> toNotificationSettingListJson(List<NotificationSetting> notificationSettingList) {
    List<Map> notificationSettingMaps = [];
    for (NotificationSetting notificationSetting in notificationSettingList) {
      notificationSettingMaps.add(notificationSetting.toJson());
    }
    return notificationSettingMaps;
  }

  static NotificationSetting? getNotificationSettingListById(
    List<NotificationSetting>? notificationSettingList,
    String id
  ) {
    if(notificationSettingList == null) {
      return null;
    }

    try{
      return notificationSettingList.firstWhere((element) => element.id == id);
    } catch(e) {
      return null;
    }
  }
}
