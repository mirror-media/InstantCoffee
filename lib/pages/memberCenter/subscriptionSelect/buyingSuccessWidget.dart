import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';

class BuyingSuccessWidget extends StatelessWidget {
  final String? storySlug;
  BuyingSuccessWidget({
    this.storySlug,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 48.0),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '您已完成本次訂購。',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 24.0),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '感謝您加入鏡週刊淨新聞閱讀行列，暢享 Premium 會員專區零廣告閱讀、優質報導看到飽。',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(height: 24.0),

        if(this.storySlug != null)...[
          Padding(
            padding: const EdgeInsets.only(left: 80.0, right: 80.0),
            child: OutlinedButton(
              style: TextButton.styleFrom(
                backgroundColor: appColor,
                padding: const EdgeInsets.only(top: 12, bottom: 12),
              ),
              child: Container(
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
              ),
              onPressed: () {
                RouteGenerator.navigateToStory(storySlug!);
              }
            ),
          ),
          SizedBox(height: 24.0),
        ],

        Padding(
          padding: const EdgeInsets.only(left: 80.0, right: 80.0),
          child: OutlinedButton(
            style: TextButton.styleFrom(
              backgroundColor: storySlug == null ? appColor : Colors.white,
              padding: const EdgeInsets.only(top: 12, bottom: 12),
            ),
            child: Container(
              child: Center(
                child: Text(
                  '回會員中心頁',
                  style: TextStyle(
                    fontSize: 17,
                    color: storySlug == null ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            onPressed: () {
              RouteGenerator.navigatorKey.currentState!.popUntil((route) => route.isFirst);
              RouteGenerator.navigateToLogin();
            }
          ),
        ),
      ],
    );
  }
}