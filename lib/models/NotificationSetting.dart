import 'package:readr_app/models/NotificationSettingList.dart';

class NotificationSetting
{
  final String type;
  final String id;
  final String title;
  final String topic;
  bool value;
  final List<NotificationSetting> notificationSettingList;

  NotificationSetting({
    this.type, 
    this.id,
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
      id: json['id'],
      title: json['title'],
      topic: json['topic'],
      value: json['value'],
      notificationSettingList: NotificationSettingList.fromJson(json['notificationSettingList']),
    );
  }

  Map<String, dynamic> toJson() =>
  {
    'type' : type,
    'id' : id,
    'title' : title,
    'topic' : topic,
    'value' : value,
    'notificationSettingList' : NotificationSettingList.toJson(notificationSettingList),
  };
}