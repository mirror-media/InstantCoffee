import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readr_app/services/app_cache_service.dart';

import '../helpers/data_constants.dart';

class RaisePriceDialogWidget extends StatelessWidget {
  const RaisePriceDialogWidget({Key? key}) : super(key: key);

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
            const Text(
              '鏡週刊APP訂閱方案\n自 2025年6月調漲！',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: appColor),
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                    height: 1.5,
                    fontSize: 16,
                    color: Colors.black), // Default style
                children: <TextSpan>[
                  TextSpan(
                      text: 'APP訂閱',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '\n月訂閱：100 元／每月'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 14, color: Colors.black), // Default style
                children: <TextSpan>[
                  TextSpan(text: '請特別注意：因技術調整，原本已訂閱的 '),
                  TextSpan(
                      text: 'Android 用戶',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: '，現有訂閱將於近期被取消，請務必重新訂閱。'),
                ],
              ),
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
                      activeColor: Colors.blue, // ✔️ 選取時框線 + 打勾的背景色
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
                    borderRadius: BorderRadius.circular(4), // 👈 這裡設定你的 R 值
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
