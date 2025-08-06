import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/widgets/sub_notice_dialog_widget.dart';

class SubNoticeDialogHelper {
  static Future<void> show(BuildContext context) async {
    final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();

    String title = remoteConfigHelper.subNoticeTitle;
    String content = remoteConfigHelper.subNoticeContent;
    String confirmText = remoteConfigHelper.subNoticeConfirmTitle;
    String confirmUrl = remoteConfigHelper.subNoticeConfirmURL;
    String cancelText = remoteConfigHelper.subNoticeCancelTitle;

    if (title.isEmpty || content.isEmpty || confirmText.isEmpty) {
      return;
    }

    Get.dialog(
      SubNoticeDialogWidget(
        title: title,
        content: content,
        confirmText: confirmText,
        confirmUrl: confirmUrl,
        cancelText: cancelText.isEmpty ? '取消' : cancelText,
      ),
      barrierDismissible: false,
    );
  }
}
