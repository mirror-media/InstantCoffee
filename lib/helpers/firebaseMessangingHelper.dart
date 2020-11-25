import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/helpers/fcm.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/fcmData.dart';
import 'package:readr_app/models/notificationSetting.dart';
import 'package:readr_app/models/notificationSettingList.dart';

class FirebaseMessangingHelper {
  bool _isInTheStoryPage;
  FirebaseMessaging _firebaseMessaging;

  FirebaseMessangingHelper() {
    _firebaseMessaging = FirebaseMessaging();
    _isInTheStoryPage = false;
  }

  configFirebaseMessaging(BuildContext context) async{
    String token = await _firebaseMessaging.getToken();
    print('FCM token: ' + token);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: Platform.isIOS ? null : Fcm.myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        if(!_isInTheStoryPage) {
          _navigateToStoryPage(context, message);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        // TODO: need to fix
        // onResume is not working on android.
        // https://github.com/FirebaseExtended/flutterfire/issues/4177
        print("onResume: $message");
        _isInTheStoryPage = false;
        _navigateToStoryPage(context, message);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  FcmData _getFcmData(Map<String, dynamic> message) {
    final Map<dynamic, dynamic> data = message['data'] ?? message;
    final FcmData fcmData = FcmData.fromJson(data);
    return fcmData;
  }

  void _navigateToStoryPage(BuildContext context, Map<String, dynamic> message) {
    FcmData fcmData = _getFcmData(message);
    
    if(fcmData != null && fcmData.slug != null) {
      _isInTheStoryPage = true;
      RouteGenerator.navigateToStory(context, fcmData.slug, isListeningWidget: fcmData.isListeningPage);
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