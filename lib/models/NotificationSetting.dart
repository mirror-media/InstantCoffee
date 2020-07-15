import 'package:readr_app/models/NotificationSettingList.dart';

class NotificationSetting
{
  final String type;
  final String title;
  final String topic;
  bool value;
  final List<NotificationSetting> notificationSettingList;

  NotificationSetting({
    this.type, 
    this.title,
    this.topic,
    this.value,
    this.notificationSettingList,
  });

  factory NotificationSetting.fromJson(Map<String, dynamic> json){
    if(json == null)
    {
      return null;
    }
    return new NotificationSetting(
      type: json['type'],
      title: json['title'],
      topic: json['topic'],
      value: json['value'],
      notificationSettingList: NotificationSettingList.fromJson(json['notificationSettingList']),
    );
  }

  Map<String, dynamic> toJson() =>
  {
    'type' : type,
    'title' : title,
    'topic' : topic,
    'value' : value,
    'notificationSettingList' : NotificationSettingList.toJson(notificationSettingList),
  };
}