import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

abstract class ShareHelper {
  /// 處理 iPad 的 sharePositionOrigin 問題
  static Future<ShareResult> shareWithPosition({
    required String text,
    String? subject,
    GlobalKey? buttonKey,
  }) async {
    Rect? sharePositionOrigin;

    if (buttonKey?.currentContext != null) {
      final RenderBox? box =
          buttonKey!.currentContext?.findRenderObject() as RenderBox?;

      if (box != null) {
        final Offset position = box.localToGlobal(Offset.zero);
        final Size size = box.size;

        sharePositionOrigin = Rect.fromLTWH(
          position.dx,
          position.dy,
          size.width,
          size.height,
        );
      }
    }

    return await Share.share(
      text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
