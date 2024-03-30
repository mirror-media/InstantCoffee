import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/core/values/image_path.dart';
import 'package:readr_app/data/enum/member_level.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/routes/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DonateBlock extends StatelessWidget {
  const DonateBlock({Key? key, this.memberLevel = MemberLevel.lv0})
      : super(key: key);
  final MemberLevel? memberLevel;

  void openDonateLink() async {
    final url = Environment().config.donateLink;
    await launchUrl(Uri.parse(url));
  }

  void gotoLogin() {
    Get.toNamed(Routes.account, id: Routes.navigationKey);
  }

  Widget renderBasicMemberBlock(bool isLogin) {
    return Container(
      width: 280,
      height: isLogin ? 301 : 357,
      padding: const EdgeInsets.symmetric(horizontal: 48),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        color: appDeepBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.25),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(4, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            '歡迎加入鏡週刊\n會員專區',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 32,
          ),
          const Text(
            '限時優惠每月\$80元\n全站看到飽',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF61B8C6),
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 17,
          ),
          Container(
            width: 200,
            height: 68,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              color: appColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(4, 4), // changes position of shadow
                ),
              ],
            ),
            child: InkWell(
              onTap: () => gotoLogin(),
              child: const Center(
                child: Text(
                  '加入PREMIUM會員',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          !isLogin
              ? Column(
                  children: [
                    const SizedBox(
                      height: 37,
                    ),
                    RichText(
                      text: TextSpan(
                          text: '已經是會員？',
                          style: const TextStyle(
                              color: Color(0xFFEBEBEB),
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    gotoLogin();
                                  },
                                text: '立即登入',
                                style: const TextStyle(
                                    color: Color(0xFFEBEBEB),
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w400))
                          ]),
                    )
                  ],
                )
              : const SizedBox.shrink(),

          // Text('已經是會員？立即登入')
        ],
      ),
    );
  }

  Widget renderDonateBlock() {
    switch (memberLevel) {
      case MemberLevel.lv0:
        return renderBasicMemberBlock(false);
      case MemberLevel.lv1:
        // TODO: Handle this case.
        return renderBasicMemberBlock(true);
      case MemberLevel.lv2:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 319,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              gradient: LinearGradient(
                colors: [Color(0xFF61B8C6), Color(0xFF054F77)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  '支持鏡週刊',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  height: 122,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const Text('小心意大意義',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black)),
                      const Text('小額贊助鏡週刊',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        height: 48,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(ImagePath.donateIcon,
                                width: 20, height: 20),
                            const SizedBox(
                              width: 4,
                            ),
                            InkWell(
                              onTap: () => openDonateLink(),
                              child: const Text(
                                '贊助本文',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  height: 122,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const Text('每月 \$49 元全站看到飽',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black)),
                      const Text('暢享無廣告閱讀體驗',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.black)),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        height: 48,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: appColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => gotoLogin(),
                              child: const Text(
                                '加入訂閱會員',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );

      case MemberLevel.lv3:
        return Container(
          width: 280,
          height: 213,
          padding: const EdgeInsets.symmetric(horizontal: 48),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(4, 4), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              Text(
                '小心意大意義，小額贊助鏡週刊',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.87),
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 44,
              ),
              Container(
                width: 200,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.25),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(4, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImagePath.donateIcon,
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () => openDonateLink(),
                        child: const Text(
                          '贊助本文',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return Text('lv0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return renderDonateBlock();
  }
}
