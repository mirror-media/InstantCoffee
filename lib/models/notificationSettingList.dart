import 'dart:convert';

import 'package:readr_app/models/customizedList.dart';
import 'package:readr_app/models/notificationSetting.dart';

class NotificationSettingList extends CustomizedList<NotificationSetting> {
  // constructor
  NotificationSettingList();

  factory NotificationSettingList.fromJson(List<dynamic> parsedJson) {
    if (parsedJson == null) {
      return null;
    }

    NotificationSettingList objects = NotificationSettingList();
    List parseList =
        parsedJson.map((i) => NotificationSetting.fromJson(i)).toList();
    parseList.forEach((element) {
      objects.add(element);
    });

    return objects;
  }

  factory NotificationSettingList.parseResponseBody(String body) {
    final jsonData = json.decode(body);

    return NotificationSettingList.fromJson(jsonData);
  }

  // your custom methods
  List<Map<dynamic, dynamic>> toJson() {
    List<Map> objects = List();
    if (l == null) {
      return null;
    }

    for (NotificationSetting object in l) {
      objects.add(object.toJson());
    }
    return objects;
  }

  String toJsonString() {
    List<Map> objects = List();
    if (l == null) {
      return null;
    }

    for (NotificationSetting object in l) {
      objects.add(object.toJson());
    }
    return json.encode(objects);
  }
}
