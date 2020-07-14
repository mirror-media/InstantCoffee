import 'dart:convert';

import 'package:readr_app/models/NotificationSetting.dart';

class NotificationSettingList {
  static List<NotifcationSetting> fromJson(List<dynamic> parsedJson){
    if(parsedJson == null)
    {
      return null;
    }
    
    List<NotifcationSetting> notificationSettingList = new List<NotifcationSetting>();
    notificationSettingList = parsedJson.map((i)=>NotifcationSetting.fromJson(i)).toList();

    return notificationSettingList;
  }

  static List<NotifcationSetting> parseResponseBody(String body){
    final jsonData = json.decode(body);
    return NotificationSettingList.fromJson(jsonData);
  }

  static List<Map<String, dynamic>> toJson(List<dynamic> notificationSettingList)
  {
    if (notificationSettingList == null) {
      return null;
    }

    List<Map<String, dynamic>> jsonList = new List<Map<String, dynamic>>();
    notificationSettingList.forEach((notifcationSetting){
      if(notifcationSetting is NotifcationSetting)
      {
        jsonList.add(
          notifcationSetting.toJson()
        );
      }
      else
      {
        jsonList.add(
          notifcationSetting
        );
      }
    });
    if (jsonList == null) {
      return [];
    }
    return jsonList;
  }
}