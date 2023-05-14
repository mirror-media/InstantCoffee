import 'package:flutter/material.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/pages/shared/premium_animate_page.dart';

class BuyingSuccessWidget extends StatelessWidget {
  final String? storySlug;
  const BuyingSuccessWidget({
    this.storySlug,
  });

  Future<void> _runPremiumAnimation() async {
    await RouteGenerator.navigatorKey.currentState!
        .pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AnimatePage(transitionAnimation: animation),
      transitionDuration: const Duration(seconds: 2),
      reverseTransitionDuration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 48.0),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '您已完成本次訂購。',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '感謝您加入鏡週刊淨新聞閱讀行列，暢享 Premium 會員專區零廣告閱讀、優質報導看到飽。',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        if (storySlug != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 80.0, right: 80.0),
            child: OutlinedButton(
                style: TextButton.styleFrom(
                  backgroundColor: appColor,
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                ),
                child: Center(
                  child: Text(
                    '回會員專區看文章',
                    style: TextStyle(
                      fontSize: 17,
                      color: storySlug == null ? appColor : Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                onPressed: () async {
                  await _runPremiumAnimation();
                  RouteGenerator.navigateToStory(storySlug!);
                }),
          ),
          const SizedBox(height: 24.0),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 80.0, right: 80.0),
          child: OutlinedButton(
              style: TextButton.styleFrom(
                backgroundColor: storySlug == null ? appColor : Colors.white,
                padding: const EdgeInsets.only(top: 12, bottom: 12),
              ),
              child: Center(
                child: Text(
                  '回首頁',
                  style: TextStyle(
                    fontSize: 17,
                    color: storySlug == null ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              onPressed: () {
                _runPremiumAnimation();
              }),
        ),
      ],
    );
  }
}
