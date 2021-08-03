import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/fcmData.dart';
import 'package:readr_app/models/notificationSetting.dart';
import 'package:readr_app/models/notificationSettingList.dart';

class FirebaseMessangingHelper {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessangingHelper();

  configFirebaseMessaging(BuildContext context) async{
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    RemoteMessage initialMessage = await _firebaseMessaging.getInitialMessage();
    _navigateToStoryPage(context, initialMessage);

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToStoryPage(context, message);
    });
  }

  void _navigateToStoryPage(BuildContext context, RemoteMessage message) {
    if(message != null ) {
      FcmData fcmData = FcmData.fromJson(message.data);
      
      if(fcmData != null && fcmData.slug != null) {
        RouteGenerator.navigateToStory(context, fcmData.slug, isListeningWidget: fcmData.isListeningPage);
      }
    }
  }

  // not use
  subscribeAllOfSubscribtionTopic() async{
    LocalStorage storage = LocalStorage('setting');
    NotificationSettingList notificationSettingList = NotificationSettingList();
    
    if (await storage.ready) {
      notificationSettingList =
          NotificationSettingList.fromJson(storage.getItem("notification"));
    }

    if (notificationSettingList == null) {
      notificationSettingList = await _getNotification(storage);
    }

    notificationSettingList.forEach(
      (notificationSetting) {
        if(notificationSetting.id == 'horoscopes' || notificationSetting.id == 'subscriptionChannels') {
          if(notificationSetting.value) {
            notificationSetting.notificationSettingList.forEach(
              (element) { 
                if(element.value) {
                  subscribeToTopic(element.topic);
                }
              }
            );
          }
        }
        else {
          if(notificationSetting.value) {
            subscribeToTopic(notificationSetting.topic);
          }
        }
      }
    );
  }

  // not use
  Future<NotificationSettingList> _getNotification(LocalStorage storage) async {
    var jsonSetting =
        await rootBundle.loadString('assets/data/defaultNotificationList.json');
    var jsonSettingList = json.decode(jsonSetting)['defaultNotificationList'];

    NotificationSettingList notificationSettingList =
        NotificationSettingList.fromJson(jsonSettingList);
    storage.setItem("notification", jsonSettingList);

    return notificationSettingList;
  }

  subscribeTheNotification(NotificationSetting notificationSetting) {
    if(notificationSetting.id == 'horoscopes' || notificationSetting.id == 'subscriptionChannels') {
      notificationSetting.notificationSettingList.forEach(
        (element) { 
          if(notificationSetting.value && element.value) {
            subscribeToTopic(element.topic);
          }
          else if(!notificationSetting.value || !element.value){
            unsubscribeFromTopic(element.topic);
          }
        }
      );
    }
    else {
      if(notificationSetting.value) {
        subscribeToTopic(notificationSetting.topic);
      }
      else {
        unsubscribeFromTopic(notificationSetting.topic);
      }
    }
  }

  subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }

  unsubscribeFromTopic(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  dispose() {}
}