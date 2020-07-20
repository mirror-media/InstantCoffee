import 'dart:convert';

import 'package:readr_app/models/CustomizedList.dart';
import 'package:readr_app/models/NotificationSetting.dart';

class NotificationSettingList extends CustomizedList<NotificationSetting> {
  // constructor
  NotificationSettingList();

  factory NotificationSettingList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    NotificationSettingList notificationSettings = NotificationSettingList();
    List parseList =
        parsedJson.map((i) => NotificationSetting.fromJson(i)).toList();
    parseList.forEach((element) {
      notificationSettings.add(element);
    });

    return notificationSettings;
  }

  factory NotificationSettingList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return NotificationSettingList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> notificationSettings = new List();
    if (l == null) {
      return null;
    }

    for (NotificationSetting notificationSetting in l) {
      notificationSettings.add(notificationSetting.toJson());
    }
    //return json.encode(notificationSettings);
    return notificationSettings;
  }

  String toJsonString() {
    List<Map> notificationSettings = new List();
    if (l == null) {
      return null;
    }

    for (NotificationSetting notificationSetting in l) {
      notificationSettings.add(notificationSetting.toJson());
    }
    return json.encode(notificationSettings);
  }
}
