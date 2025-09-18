import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/memberCenter/memberDetail/member_detail_cubit.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/login/member_widget/anonymous_bind_page/anonymous_bind_page.dart';
import 'package:readr_app/pages/login/member_widget/anonymous_block/anonymous_block_controller.dart';
import 'package:readr_app/pages/memberCenter/subscriptionDetail/member_subscription_detail_page.dart';
import 'package:readr_app/pages/shared/app_version_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AnonymousBlockWidget extends StatelessWidget {
  AnonymousBlockWidget({Key? key, required this.subscriptionType})
      : super(key: key);
  final SubscriptionType subscriptionType;
  final AnonymousBlockController controller =
      Get.put(AnonymousBlockController());

  // 檢查 isFreePremium 功能
  bool _isFreePremiumEnabled() {
    try {
      final RemoteConfigHelper remoteConfigHelper = RemoteConfigHelper();
      return remoteConfigHelper.isFreePremium;
    } catch (e) {
      // RemoteConfig 未初始化時回傳 false
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              const Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                child: Text(
                  '我的會員等級',
                  style: TextStyle(fontSize: 15, color: appColor),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Obx(() {
                  final authInfoSubscriptionType = controller
                      .authInfoProvider.rxnUserAuthInfo.value?.subscriptionType;
                  return Text(
                      authInfoSubscriptionType == SubscriptionType.none
                          ? '匿名訪客'
                          : '訂閱訪客',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500));
                }),
              ),
              const SizedBox(height: 24),
              const Divider(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BlocProvider(
                              child: MemberSubscriptionDetailPage(
                                subscriptionType: subscriptionType,
                              ),
                              create: (BuildContext context) =>
                                  MemberDetailCubit());
                        }));
                      },
                      child: const SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Text('我的方案細節'),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.grey,
                              size: 16,
                            )
                          ],
                        ),
                      ),
                    ),
                    Obx(() {
                      final authInfoSubscriptionType = controller
                          .authInfoProvider
                          .rxnUserAuthInfo
                          .value
                          ?.subscriptionType;
                      return authInfoSubscriptionType ==
                                  SubscriptionType.none &&
                              !_isFreePremiumEnabled()
                          ? Column(
                              children: [
                                const Divider(
                                  height: 0,
                                ),
                                InkWell(
                                  onTap: () {
                                    RouteGenerator
                                        .navigateToSubscriptionSelect();
                                  },
                                  child: const SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Text('升級Premium會員'),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Colors.grey,
                                          size: 16,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 0,
                                ),
                                InkWell(
                                  onTap: controller.restorePurchasesButtonClick,
                                  child: const SizedBox(
                                    height: 50,
                                    child: Row(
                                      children: [
                                        Text('恢復訂閱資格'),
                                        Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          color: Colors.grey,
                                          size: 16,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              const Divider(
                height: 0,
              ),
              Container(
                height: 24,
                width: double.infinity,
                color: const Color(0x1C000000),
              ),
              const Divider(
                height: 0,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => AnonymousBindPage());
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 82,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '註冊正式會員',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text('系統將自動綁定您目前的訂閱方案',
                          style: TextStyle(
                              fontSize: 17, color: Color(0x99000000))),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  height: 0,
                ),
              ),
              InkWell(
                onTap: controller.signOutButtonClick,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 82,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '以其他帳號登入',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 0,
              ),
              Wrap(children: [
                Container(
                  height: 24,
                  width: double.infinity,
                  color: const Color(0x1C000000),
                ),
                const SizedBox(height: 16),
                InkWell(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: SizedBox(
                        width: Get.width,
                        child: const Text(
                          '聯絡我們',
                          style: TextStyle(
                              color: Color(0xff4A4A4A), fontSize: 16.0),
                        ),
                      ),
                    ),
                    onTap: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: mirrorMediaServiceEmail,
                      );

                      if (await canLaunchUrlString(emailLaunchUri.toString())) {
                        await launchUrlString(emailLaunchUri.toString());
                      } else {
                        throw 'Could not launch $mirrorMediaServiceEmail';
                      }
                    }),
                InkWell(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: SizedBox(
                        width: Get.width,
                        child: const Text(
                          '隱私條款',
                          style: TextStyle(
                              color: Color(0xff4A4A4A), fontSize: 16.0),
                        ),
                      ),
                    ),
                    onTap: () async {
                      RouteGenerator.navigateToStory('privacy',
                          isMemberCheck: false);
                    }),
                InkWell(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                      child: SizedBox(
                        width: Get.width,
                        child: const Text(
                          '服務條款',
                          style: TextStyle(
                              color: Color(0xff4A4A4A), fontSize: 16.0),
                        ),
                      ),
                    ),
                    onTap: () {
                      RouteGenerator.navigateToStory('service-rule',
                          isMemberCheck: false);
                    }),
                const SizedBox(height: 16),
                Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: AppVersionWidget()),
              ])
            ],
          ),
          Obx(() {
            final isLoading = controller.rxIsLoading.value;
            return Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            );
          })
        ],
      ),
    );
  }
}
