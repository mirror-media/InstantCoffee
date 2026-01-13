import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/helpers/error_log_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/fcm_data.dart';
import 'package:readr_app/models/notification_setting.dart';
import 'package:readr_app/widgets/logger.dart';

class FirebaseMessangingHelper with Logger {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessangingHelper();

  configFirebaseMessaging() async {
    if (!Platform.isAndroid) {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugLog('User granted permission: ${settings.authorizationStatus}');
    }

    FirebaseMessaging.instance.getInitialMessage().then((initialMessage) {
      if (initialMessage != null) {
        _navigateToStoryPage(initialMessage);
      }
    });

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToStoryPage(message);
    });
  }

  void _navigateToStoryPage(RemoteMessage? message) {
    if (message == null) return;
    FcmData? fcmData;
    try {
      fcmData = FcmData.fromJson(message.data);

      if (fcmData.slug != null) {
        if (fcmData.isListeningPage) {
          RouteGenerator.navigateToListeningStory(fcmData.slug!);
        } else {
          RouteGenerator.navigateToStory(fcmData.slug!);
        }
      }
    } catch (e, s) {
      String? slug = fcmData?.slug;
      ErrorLogHelper().record(
          Exception(
              '[Firebase Messaging NavigateToStoryPage] fcmDataSlug: $slug'),
          s);
    }
  }

  // not use
  subscribeAllOfSubscribtionTopic() async {
    LocalStorage storage = LocalStorage('setting');
    List<NotificationSetting>? notificationSettingList;

    if (await storage.ready) {
      if (storage.getItem("notification") != null) {
        notificationSettingList =
            NotificationSetting.notificationSettingListFromJson(
                storage.getItem("notification"));
      }
    }

    notificationSettingList ??= await _getNotification(storage);

    for (var notificationSetting in notificationSettingList) {
      if (notificationSetting.id == 'horoscopes' ||
          notificationSetting.id == 'subscriptionChannels') {
        if (notificationSetting.value &&
            notificationSetting.notificationSettingList != null) {
          for (var element in notificationSetting.notificationSettingList!) {
            if (element.value) {
              subscribeToTopic(element.topic!);
            }
          }
        }
      } else {
        if (notificationSetting.value) {
          subscribeToTopic(notificationSetting.topic!);
        }
      }
    }
  }

  // not use
  Future<List<NotificationSetting>> _getNotification(
      LocalStorage storage) async {
    var jsonSetting =
        await rootBundle.loadString('assets/data/defaultNotificationList.json');
    var jsonSettingList = json.decode(jsonSetting)['defaultNotificationList'];

    List<NotificationSetting> notificationSettingList =
        NotificationSetting.notificationSettingListFromJson(jsonSettingList);
    storage.setItem("notification", jsonSettingList);

    return notificationSettingList;
  }

  subscribeTheNotification(NotificationSetting notificationSetting) {
    if (notificationSetting.id == 'horoscopes' ||
        notificationSetting.id == 'subscriptionChannels') {
      for (var element in notificationSetting.notificationSettingList!) {
        if (notificationSetting.value && element.value) {
          subscribeToTopic(element.topic!);
        } else if (!notificationSetting.value || !element.value) {
          unsubscribeFromTopic(element.topic!);
        }
      }
    } else {
      if (notificationSetting.value) {
        subscribeToTopic(notificationSetting.topic!);
      } else {
        unsubscribeFromTopic(notificationSetting.topic!);
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
