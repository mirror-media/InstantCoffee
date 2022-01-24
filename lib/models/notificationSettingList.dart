import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/notificationSetting.dart';

class NotificationSettingList extends CustomizedList<NotificationSetting> {
  // constructor
  NotificationSettingList();

  factory NotificationSettingList.fromJson(List<dynamic> parsedJson) {
    NotificationSettingList notificationSettings = NotificationSettingList();
    List parseList =
        parsedJson.map((i) => NotificationSetting.fromJson(i)).toList();
    parseList.forEach((element) {
      notificationSettings.add(element);
    });

    return notificationSettings;
  }

  static NotificationSettingList? parseResponseBody(String? body) {
    if (body == null) {
      return null;
    }

    final jsonData = json.decode(body);
    return NotificationSettingList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> notificationSettingMaps = [];
    for (NotificationSetting notificationSetting in l) {
      notificationSettingMaps.add(notificationSetting.toJson());
    }
    return notificationSettingMaps;
  }

  String toJsonString() {
    List<Map> notificationSettingMaps = [];
    for (NotificationSetting notificationSetting in l) {
      notificationSettingMaps.add(notificationSetting.toJson());
    }
    return json.encode(notificationSettingMaps);
  }

  NotificationSetting? getById(String id) {
    try{
      return l.firstWhere((element) => element.id == id);
    } catch(e) {
      return null;
    }
  }
}
