import 'dart:convert';

import 'package:readr_app/models/NotificationSetting.dart';

class NotificationSettingList {
  static List<NotificationSetting> fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    List<NotificationSetting> notificationSettingList =
        new List<NotificationSetting>();
    notificationSettingList =
        parsedJson.map((i) => NotificationSetting.fromJson(i)).toList();

    return notificationSettingList;
  }

  static List<NotificationSetting> parseResponseBody(String body) {
    final jsonData = json.decode(body);
    return NotificationSettingList.fromJson(jsonData);
  }

  static List<Map<String, dynamic>> toJson(
      List<dynamic> notificationSettingList) {
    if (notificationSettingList == null) {
      return null;
    }

    List<Map<String, dynamic>> jsonList = new List<Map<String, dynamic>>();
    notificationSettingList.forEach((notificationSetting) {
      if (notificationSetting is NotificationSetting) {
        jsonList.add(notificationSetting.toJson());
      } else {
        jsonList.add(notificationSetting);
      }
    });
    if (jsonList == null) {
      return [];
    }
    return jsonList;
  }
}
