import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:readr_app/blocs/member/bloc.dart';
import 'package:readr_app/blocs/memberCenter/memberDetail/member_detail_cubit.dart';
import 'package:readr_app/blocs/memberCenter/paymentRecord/payment_record_bloc.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/memberCenter/paymentRecord/member_payment_record_page.dart';
import 'package:readr_app/pages/memberCenter/subscriptionDetail/member_subscription_detail_page.dart';
import 'package:readr_app/pages/passwordUpdate/password_update_page.dart';
import 'package:readr_app/pages/shared/app_version_widget.dart';
import 'package:readr_app/pages/shared/member_subscription_type_title_widget.dart';
import 'package:readr_app/pages/shared/premium_animate_page.dart';
import 'package:readr_app/services/login_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PremiumMemberWidget extends StatefulWidget {
  final String israfelId;
  final SubscriptionType subscriptionType;
  const PremiumMemberWidget({
    required this.israfelId,
    required this.subscriptionType,
  });

  @override
  _PremiumMemberWidgetState createState() => _PremiumMemberWidgetState();
}

class _PremiumMemberWidgetState extends State<PremiumMemberWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _signOut() async {
    await GoogleSignIn().disconnect();
    await _auth.signOut();
    await RouteGenerator.navigatorKey.currentState!.push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          AnimatePage(transitionAnimation: animation),
      transitionDuration: const Duration(milliseconds: 1500),
      reverseTransitionDuration: const Duration(milliseconds: 1000),
    ));
    context.read<MemberBloc>().add(UpdateSubscriptionType(
        isLogin: false, israfelId: null, subscriptionType: null));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xffE5E5E5),
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          '會員中心',
          style: TextStyle(
              color: appColor, fontSize: 20, fontWeight: FontWeight.w400),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 12),
              child: _memberLevelBlock(widget.subscriptionType),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                if (widget.subscriptionType != SubscriptionType.staff) ...[
                  _horizontalDivider(width),
                  _memberSubscriptionDetailButton(widget.subscriptionType),
                  if (widget.subscriptionType != SubscriptionType.marketing &&
                      widget.subscriptionType !=
                          SubscriptionType.subscribe_group) ...[
                    _horizontalDivider(width),
                    _memberPaymentRecordButton(widget.subscriptionType),
                  ],
                ],
                _horizontalDivider(width),
                _memberProfileButton(),
                _horizontalDivider(width),
                if (LoginServices.checkIsEmailAndPasswordLogin()) ...[
                  _changePasswordButton(),
                  _horizontalDivider(width),
                ],
                _memberContactInfoButton(),
                _horizontalDivider(width),
                _settingButton(),
                Container(
                  color: const Color(0xffF4F4F4),
                  child: _logoutButton(width),
                ),
                _horizontalDivider(width),
                _deleteMemberButton(width),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                    height: 185, width: width, child: _contactInfo(width))),
          ),
        ],
      ),
    );
  }

  Widget _memberLevelBlock(SubscriptionType subscriptionType) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: Text(
          '我的會員等級',
          style: TextStyle(fontSize: 15),
        ),
      ),
      const SizedBox(height: 4),
      Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: MemberSubscriptionTypeTitleWiget(
          subscriptionType: subscriptionType,
          textStyle: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: appColor,
          ),
        ),
      ),
    ]);
  }

  Widget _horizontalDivider(double width) {
    return Container(
      color: const Color(0xffDADADA),
      width: width,
      height: 1,
    );
  }

  Widget _memberSubscriptionDetailButton(SubscriptionType subscriptionType) {
    return _navigateButton(
      '我的方案細節',
      () => Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BlocProvider(
            child: MemberSubscriptionDetailPage(
              subscriptionType: subscriptionType,
            ),
            create: (BuildContext context) => MemberDetailCubit());
      })),
    );
  }

  Widget _memberPaymentRecordButton(SubscriptionType subscriptionType) {
    return _navigateButton(
      '付款紀錄',
      () => Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BlocProvider(
          create: (BuildContext context) => PaymentRecordBloc(),
          child: MemberPaymentRecordPage(subscriptionType),
        );
      })),
    );
  }

  Widget _memberProfileButton() {
    return _navigateButton(
      '個人資料',
      () => RouteGenerator.navigateToEditMemberProfile(),
    );
  }

  Widget _changePasswordButton() {
    return _navigateButton(
      '修改密碼',
      () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => const PasswordUpdatePage(isPremium: true),
        ));
      },
    );
  }

  Widget _memberContactInfoButton() {
    return _navigateButton(
      '聯絡資訊',
      () => RouteGenerator.navigateToEditMemberContactInfo(),
    );
  }

  Widget _settingButton() {
    return _navigateButton(
      '設定',
      () => RouteGenerator.navigateToPremiumSettingPage(),
    );
  }

  Widget _navigateButton(String title, GestureTapCallback onTap) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 17,
              ),
            ],
          ),
        ));
  }

  Widget _logoutButton(double width) {
    final ButtonStyle flatButtonStyle = ButtonStyle(
      overlayColor: MaterialStateProperty.all(Colors.grey[350]),
      padding: MaterialStateProperty.all(
        const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
      ),
    );

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: SizedBox(
          width: width,
          child: const Text(
            '登出',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              surfaceTintColor: Colors.white,
              title: const Text('登出'),
              content: const Text('是否確定登出？'),
              actions: <Widget>[
                TextButton(
                  style: flatButtonStyle,
                  child: const Text(
                    '取消',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                    style: flatButtonStyle,
                    child: const Text(
                      '確認',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      _signOut();
                      Navigator.of(context).pop();
                    })
              ],
            );
          },
        );
      },
    );
  }

  Widget _deleteMemberButton(double width) {
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: SizedBox(
            width: width,
            child: const Text(
              '刪除帳號',
              style: TextStyle(
                fontSize: 17,
                color: Colors.red,
              ),
            ),
          ),
        ),
        onTap: () => RouteGenerator.navigateToDeleteMember(
            widget.israfelId, widget.subscriptionType));
  }

  Widget _contactInfo(double width) {
    return Wrap(children: [
      Container(
        color: appColor,
        width: width,
        height: 1,
      ),
      const SizedBox(height: 16),
      InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: SizedBox(
              width: width,
              child: const Text(
                '聯絡我們',
                style: TextStyle(color: Color(0xff4A4A4A), fontSize: 16.0),
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
              width: width,
              child: const Text(
                '隱私條款',
                style: TextStyle(color: Color(0xff4A4A4A), fontSize: 16.0),
              ),
            ),
          ),
          onTap: () async {
            RouteGenerator.navigateToStory('privacy', isMemberCheck: false);
          }),
      InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: SizedBox(
              width: width,
              child: const Text(
                '服務條款',
                style: TextStyle(color: Color(0xff4A4A4A), fontSize: 16.0),
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
    ]);
  }
}
