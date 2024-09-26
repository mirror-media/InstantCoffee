import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/bloc.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/events.dart';
import 'package:readr_app/blocs/memberCenter/subscriptionSelect/states.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/helpers/remote_config_helper.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/helpers/url_launcher.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/models/payment_record.dart';
import 'package:readr_app/models/subscription_detail.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/buying_success_widget.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/hint_to_other_platform.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/verify_purchase_fail_widget.dart';
import 'package:readr_app/widgets/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SubscriptionSelectWidget extends StatefulWidget {
  const SubscriptionSelectWidget();

  @override
  _SubscriptionSelectWidgetState createState() =>
      _SubscriptionSelectWidgetState();
}

class _SubscriptionSelectWidgetState extends State<SubscriptionSelectWidget>
    with Logger {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionProducts();
  }

  bool _isSubscribed(SubscriptionType? subscriptionType) {
    return subscriptionType == SubscriptionType.subscribe_monthly ||
        subscriptionType == SubscriptionType.subscribe_yearly;
  }

  bool _isTheSamePlatfrom(PaymentType? paymentType) {
    if (paymentType == null) {
      return true;
    }

    if (paymentType == PaymentType.google_play && Platform.isAndroid) {
      return true;
    } else if (paymentType == PaymentType.app_store && Platform.isIOS) {
      return true;
    }

    return false;
  }

  _fetchSubscriptionProducts() {
    context.read<SubscriptionSelectBloc>().add(FetchSubscriptionProducts());
  }

  _buySubscriptionProduct(PurchaseParam purchaseParam) {
    context
        .read<SubscriptionSelectBloc>()
        .add(BuySubscriptionProduct(purchaseParam));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionSelectBloc, SubscriptionSelectState>(
        builder: (BuildContext context, SubscriptionSelectState state) {
      switch (state.status) {
        case SubscriptionSelectStatus.error:
          final error = state.errorMessages;
          debugLog('SubscriptionProductsLoadedFail: ${error.message}');
          return Container();
        case SubscriptionSelectStatus.loaded:
          SubscriptionDetail subscriptionDetail = state.subscriptionDetail!;
          List<ProductDetails> productDetailList = state.productDetailList!;

          Widget? body;

          if (_isTheSamePlatfrom(subscriptionDetail.paymentType)) {
            body = ListView(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: _memberIntroBlock(
                      subscriptionDetail.subscriptionType, productDetailList),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: _memberAttention(),
                ),
                const SizedBox(height: 48),
              ],
            );
          } else {
            body = HintToOtherPlatform(
                paymentType: subscriptionDetail.paymentType!);
          }

          return Scaffold(
              appBar: _buildBar(context,
                  subscriptionType: subscriptionDetail.subscriptionType),
              body: body);
        case SubscriptionSelectStatus.buying:
          SubscriptionDetail subscriptionDetail = state.subscriptionDetail!;
          List<ProductDetails> productDetailList = state.productDetailList!;

          return Scaffold(
            appBar: _buildBar(context,
                subscriptionType: subscriptionDetail.subscriptionType),
            body: ListView(
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: _memberIntroBlock(
                      subscriptionDetail.subscriptionType, productDetailList,
                      isBuying: true),
                ),
                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: _memberAttention(),
                ),
                const SizedBox(height: 48),
              ],
            ),
          );
        case SubscriptionSelectStatus.buyingSuccess:
          String? storySlug = state.storySlug;

          return Scaffold(
              appBar: _buildBar(context),
              body: BuyingSuccessWidget(storySlug: storySlug));
        case SubscriptionSelectStatus.verifyPurchaseFail:
          return Scaffold(
              appBar: _buildBar(context), body: VerifyPurchaseFailWidget());
        default:
          // state is Init, Loading
          return Scaffold(appBar: _buildBar(context), body: _loadingWidget());
      }
    });
  }

  PreferredSizeWidget _buildBar(BuildContext context,
      {SubscriptionType? subscriptionType}) {
    String titleText = '';
    if (subscriptionType == SubscriptionType.subscribe_one_time ||
        subscriptionType == SubscriptionType.none) {
      titleText = '升級會員';
    } else if (_isSubscribed(subscriptionType)) {
      titleText = '變更方案';
    }

    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        titleText,
      ),
      backgroundColor: appColor,
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _memberIntroBlock(
      SubscriptionType subscriptionType, List<ProductDetails> productDetailList,
      {bool isBuying = false}) {
    double width = MediaQuery.of(context).size.width;
    String boxTitle = 'Premium 會員';
    if (subscriptionType == SubscriptionType.subscribe_monthly) {
      boxTitle = '變更為年訂閱方案';
    } else if (subscriptionType == SubscriptionType.subscribe_yearly) {
      boxTitle = '變更為月訂閱方案';
    }

    int originalPrice = 99;
    int specialPrice = 80;

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.grey, spreadRadius: 1, blurRadius: 10),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    boxTitle,
                    style: const TextStyle(
                      color: appColor,
                      fontSize: 20,
                    ),
                  ),
                  Image.asset(
                    'assets/image/badge.png',
                    width: 60,
                    height: 80,
                  ),
                ],
              ),
              _memberClause('支持鏡週刊報導精神'),
              const Divider(),
              _memberClause('暢讀鏡週刊全站內容'),
              const Divider(),
              _memberClause('會員專區零廣告純淨閱覽'),
              const Divider(),
              _memberClause('專區好文不分頁流暢閱讀'),
              const Divider(),
              _memberClause('免費閱讀數位版動態雜誌'),
              const Divider(),
              _memberClause('月方案定價 ${productDetailList[0].price} 元'),
              const SizedBox(height: 24),
              isBuying
                  ? const Column(
                      children: [
                        Text(
                          '購買中',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 4),
                        SpinKitThreeBounce(
                          color: appColor,
                          size: 35,
                        ),
                      ],
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 12),
                      itemCount: productDetailList.length,
                      itemBuilder: (context, index) {
                        final ButtonStyle buttonStyle = TextButton.styleFrom(
                          backgroundColor:
                              index % 2 == 0 ? appColor : Colors.white,
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                        );

                        return OutlinedButton(
                          style: buttonStyle,
                          child: SizedBox(
                            width: width,
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    productDetailList[index].title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: index % 2 == 0
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '優惠 ${productDetailList[0].price} 元',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: index % 2 == 0
                                          ? Colors.white60
                                          : Colors.black38,
                                    ),
                                  ),
                                  Text(
                                    productDetailList[index].description,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: index % 2 == 0
                                          ? Colors.white60
                                          : Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_auth.currentUser == null) {
                              RouteGenerator.navigateToLogin(
                                routeName: RouteGenerator.subscriptionSelect,
                                routeArguments: {
                                  'storySlug': '',
                                },
                              );
                            } else {
                              await _auth.currentUser!.reload();
                              if (_auth.currentUser!.emailVerified) {
                                PurchaseParam purchaseParam = PurchaseParam(
                                  productDetails: productDetailList[index],
                                );

                                if (Platform.isAndroid) {
                                  final RemoteConfigHelper _remoteConfigHelper =
                                      RemoteConfigHelper();

                                  if (_remoteConfigHelper.isSubscriptShow) {
                                    const String kProductID =
                                        'subscribe_monthly_80';
                                    final bool available = await InAppPurchase
                                        .instance
                                        .isAvailable();
                                    if (!available) {
                                      print('Store is not available');
                                      return;
                                    }

                                    const Set<String> kIds = <String>{
                                      kProductID
                                    };
                                    final ProductDetailsResponse response =
                                        await InAppPurchase.instance
                                            .queryProductDetails(kIds);
                                    if (response.notFoundIDs.isNotEmpty) {
                                      print('Product not found');
                                      return;
                                    }

                                    final ProductDetails productDetails =
                                        response.productDetails.first;
                                    final PurchaseParam purchaseParam =
                                        PurchaseParam(
                                            productDetails: productDetails);
                                    _buySubscriptionProduct(purchaseParam);
                                  } else {
                                    final link = Uri.parse(
                                        Environment().config.subscriptionLink);
                                    if (await canLaunchUrl(link)) {
                                      await launchUrl(link);
                                    }
                                  }
                                } else {
                                  _buySubscriptionProduct(purchaseParam);
                                }
                              } else {
                                RouteGenerator.navigateToEmailVerification();
                              }
                            }
                          },
                        );
                      }),
              if (_isSubscribed(subscriptionType)) ...[
                const SizedBox(height: 12),
                const Text(
                  '變更將在本次收費週期結束時生效',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ]
            ],
          ),
        ));
  }

  Widget _memberClause(String title, {Color textColor = Colors.black54}) {
    return Row(children: [
      const Icon(
        Icons.check,
        color: appColor,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        ),
      ),
    ]);
  }

  Widget _memberAttention() {
    final String platfromName =
        Platform.isAndroid ? 'Google play' : 'App store';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '自動續訂服務說明',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 12),
        _orderClause(1, '月訂閱服務以30天為一期。訂閱後將會透過您的 $platfromName 帳號直接進行扣款。'),
        _orderClause(2, '本訂閱方案採自動續訂，訂閱到期日前24小時內，自動續訂扣款。付款成功後會順延一個訂閱週期。'),
        _orderCancelSubscription(3),
        _orderContactEmail(4),
        _orderTermsOfService(5),
      ],
    );
  }

  Widget _orderClause(int order, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            "$order.",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCancelSubscription(int order) {
    final String cancelSubscriptionUrl = Platform.isAndroid
        ? 'https://support.google.com/googleplay/answer/7018481'
        : 'https://support.apple.com/HT202039';
    final String platfromName = Platform.isAndroid ? 'Google' : 'Apple';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            "$order.",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        '若要取消自動續訂，請在訂閱到期日至少三日前取消訂閱。相關步驟請參照 $platfromName 官方網站操作說明：',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: '取消 $platfromName 訂閱項目',
                    style: const TextStyle(
                      fontSize: 16,
                      color: appColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        if (await canLaunchUrlString(cancelSubscriptionUrl)) {
                          await launchUrlString(cancelSubscriptionUrl);
                        } else {
                          throw 'Could not launch $cancelSubscriptionUrl';
                        }
                      },
                  ),
                  const TextSpan(
                    text: '。',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderContactEmail(int order) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            "$order.",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: '訂閱相關問題請 email 至會員專屬客服信箱 ',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: mirrorMediaServiceEmail,
                    style: const TextStyle(
                      fontSize: 16,
                      color: appColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: mirrorMediaServiceEmail,
                        );

                        if (await canLaunchUrlString(
                            emailLaunchUri.toString())) {
                          await launchUrlString(emailLaunchUri.toString());
                        } else {
                          throw 'Could not launch $mirrorMediaServiceEmail';
                        }
                      },
                  ),
                  const TextSpan(
                    text: '， 我們會盡快為您協助處理。',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderTermsOfService(int order) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            "$order.",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: '更多詳細內容，請至',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  TextSpan(
                    text: '服務條款',
                    style: const TextStyle(
                      fontSize: 16,
                      color: appColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        RouteGenerator.navigateToStory(
                          'service-rule',
                          isMemberCheck: false,
                        );
                      },
                  ),
                  const TextSpan(
                    text: '。',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
