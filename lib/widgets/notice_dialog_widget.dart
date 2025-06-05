import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/services/app_cache_service.dart';
import '../helpers/data_constants.dart';

class NoticeDialogWidget extends StatelessWidget {
  final String title;
  final String content;

  const NoticeDialogWidget({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxBool showAgain = false.obs;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
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
            const SizedBox(height: 16),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: showAgain.value,
                      onChanged: (value) {
                        showAgain.value = value ?? false;
                      },
                      activeColor: Colors.blue,
                      checkColor: Colors.white,
                    ),
                    const Text('以後不再通知',
                        style: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5))),
                  ],
                )),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final controller = Get.find<AppCacheService>();
                  controller.setBool(
                      AppCacheService.raisePriceNotShowAgain, showAgain.value);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('我知道了'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
