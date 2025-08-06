import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helpers/data_constants.dart';

class SubNoticeDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String confirmUrl;
  final String cancelText;

  const SubNoticeDialogWidget({
    Key? key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.confirmUrl,
    required this.cancelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title.replaceAll('\\n', '\n'), // 將 \n 字符串轉換為實際換行
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: appColor),
            ),
            const SizedBox(height: 16),
            Text(
              content.replaceAll('\\n', '\n'), // 將 \n 字符串轉換為實際換行
              textAlign: TextAlign.center,
              style: const TextStyle(
                  height: 1.5, fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (confirmUrl.isNotEmpty) {
                    // 如果有 URL，使用外部瀏覽器開啟
                    final link = Uri.parse(confirmUrl);
                    if (await canLaunchUrl(link)) {
                      await launchUrl(link,
                          mode: LaunchMode.externalApplication);
                    }
                  }
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  confirmText,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  cancelText,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
