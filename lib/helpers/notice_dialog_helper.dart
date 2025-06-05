import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/services/app_cache_service.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/widgets/notice_dialog_widget.dart';

class NoticeDialogHelper {
  static Future<void> showIfNeeded(BuildContext context) async {
    final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();
    final AppCacheService cacheService = Get.find<AppCacheService>();

    bool isEnabled = remoteConfigHelper.isNoticeDialogEnabled;
    String title = remoteConfigHelper.noticeDialogTitle;
    String content = remoteConfigHelper.noticeDialogContent;
    String version = remoteConfigHelper.noticeDialogVersion;

    if (!isEnabled || title.isEmpty || content.isEmpty || version.isEmpty) {
      return;
    }

    String cacheKey = 'notice_dialog_not_show_again_$version';
    bool notShowAgain = cacheService.getBool(cacheKey) ?? false;

    if (notShowAgain) {
      return;
    }

    Get.dialog(
      NoticeDialogWidget(
        title: title,
        content: content,
        cacheKey: cacheKey,
      ),
      barrierDismissible: false,
    ).then((value) {});
  }
}
