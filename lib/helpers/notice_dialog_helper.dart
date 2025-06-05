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

    if (!isEnabled) {
      return;
    }

    // 如果已啟用，但標題或內容為空，則不顯示
    String title = remoteConfigHelper.noticeDialogTitle;
    String content = remoteConfigHelper.noticeDialogContent;
    if (title.isEmpty || content.isEmpty) {
      return;
    }

    bool notShowAgain =
        cacheService.getBool(AppCacheService.raisePriceNotShowAgain) ?? false;

    if (notShowAgain) {
      return;
    }

    Get.dialog(
      NoticeDialogWidget(title: title, content: content),
      barrierDismissible: false,
    ).then((value) {});
  }
}
