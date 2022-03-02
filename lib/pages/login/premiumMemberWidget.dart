import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/memberCenter/memberDetail/memberDetailCubit.dart';
import 'package:readr_app/blocs/memberCenter/paymentRecord/paymentRecordBloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/pages/memberCenter/paymentRecord/memberPaymentRecordPage.dart';
import 'package:readr_app/pages/memberCenter/subscriptionDetail/memberSubscriptionDetailPage.dart';
import 'package:readr_app/pages/shared/appVersionWidget.dart';
import 'package:readr_app/pages/shared/memberSubscriptionTypeTitleWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumMemberWidget extends StatefulWidget {
  final String israfelId;
  final SubscriptionType subscriptionType;
  PremiumMemberWidget({
    required this.israfelId,
    required this.subscriptionType,
  });
  
  @override
  _PremiumMemberWidgetState createState() => _PremiumMemberWidgetState();
}

class _PremiumMemberWidgetState extends State<PremiumMemberWidget> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  
  _signOut() async {
    await _auth.signOut();
  }
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xffE5E5E5),
        elevation: 0.0,
        title: Text(
          '會員中心',
          style: TextStyle(
            color: appColor,
            fontSize: 20,
            fontWeight: FontWeight.w400
          ),
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
                if(widget.subscriptionType != SubscriptionType.staff)...[
                  _horizontalDivider(width),
                  _memberSubscriptionDetailButton(widget.subscriptionType),
                  if(widget.subscriptionType != SubscriptionType.marketing && 
                    widget.subscriptionType != SubscriptionType.subscribe_group
                  )...[
                    _horizontalDivider(width),
                    _memberPaymentRecordButton(widget.subscriptionType),
                  ],
                ],

                _horizontalDivider(width),
                _memberProfileButton(),
                _horizontalDivider(width),
                // if (LoginServices.checkIsEmailAndPasswordLogin()) ...[
                //   _changePasswordButton(),
                //   _horizontalDivider(width),
                // ],
                _memberContactInfoButton(),
                _horizontalDivider(width),
                _settingButton(),
                Container(
                  color: Color(0xffF4F4F4),
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
              child: Container(
                height: 185,
                width: width,
                child: _contactInfo(width)
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberLevelBlock(SubscriptionType subscriptionType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '我的會員等級',
            style: TextStyle(fontSize: 15),
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: MemberSubscriptionTypeTitleWiget(
            subscriptionType: subscriptionType,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: appColor,
          ),
        ),
      ]
    );
  }

  Widget _horizontalDivider(double width) {
    return Container(
      color: Color(0xffDADADA),
      width: width,
      height: 1,
    );
  }

  Widget _memberSubscriptionDetailButton(SubscriptionType subscriptionType) {
    return _navigateButton(
      '我的方案細節',
      () => Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return BlocProvider(
              child: MemberSubscriptionDetailPage(subscriptionType: subscriptionType,),
              create: (BuildContext context) =>
                  MemberDetailCubit());
                  }
                )
              ),
    );
  }

  Widget _memberPaymentRecordButton(SubscriptionType subscriptionType) {
    return _navigateButton(
      '付款紀錄',
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return BlocProvider(
            create: (BuildContext context) => PaymentRecordBloc(),
            child: MemberPaymentRecordPage(subscriptionType),
            );
          }
        )
      ),
    );
  }

  Widget _memberProfileButton() {
    return _navigateButton(
      '個人資料',
      () => RouteGenerator.navigateToEditMemberProfile(),
    );
  }

  // TODO: fixes changing password feature in premium mode
  // Widget _changePasswordButton() {
  //   return _navigateButton(
  //     '修改密碼',
  //     () {
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (_) => BlocProvider.value(
  //             value: BlocProvider.of<LoginBloc>(context),
  //             child: PasswordUpdatePage(),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _memberContactInfoButton() {
    return _navigateButton(
      '聯絡資訊',
      () => RouteGenerator.navigateToEditMemberContactInfo(),
    );
  }

  Widget _settingButton() {
    return _navigateButton(
      '設定',
      () {}
    );
  }

  Widget _navigateButton(String title, GestureTapCallback onTap) {
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 17,
              ),
            ],
          ),
        ),
        onTap: onTap);
  }

  Widget _logoutButton(double width) {
    final ButtonStyle flatButtonStyle = ButtonStyle(
      overlayColor: MaterialStateProperty.all(Colors.grey[350]),
      padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),),
    );

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        child: Container(
          width: width,
          child: Text(
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
              title: Text('登出'),
              content: Text('是否確定登出？'),
              actions: <Widget>[
                TextButton(
                  style: flatButtonStyle,
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                    style: flatButtonStyle,
                    child: Text(
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
        child: Container(
          width: width,
          child: Text(
            '刪除帳號',
            style: TextStyle(
              fontSize: 17,
              color: Colors.red,
            ),
          ),
        ),
      ),
      onTap: () => RouteGenerator.navigateToDeleteMember(
        widget.israfelId,
        widget.subscriptionType
      )
    );
  }

  Widget _contactInfo(double width) {
    return Wrap(
      children: [
        Container(
          color: appColor,
          width: width,
          height: 1,
        ),
        SizedBox(height: 16),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Container(
              width: width,
              child: Text(
                '聯絡我們',
                style: TextStyle(color: Color(0xff4A4A4A), fontSize: 16.0),
              ),
            ),
          ),
          onTap: () async{
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: mirrorMediaServiceEmail,
            );

            if (await canLaunch(emailLaunchUri.toString())) {
              await launch(emailLaunchUri.toString());
            } else {
              throw 'Could not launch $mirrorMediaServiceEmail';
            }
          }
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Container(
              width: width,
              child: Text(
                '隱私條款',
                style: TextStyle(color: Color(0xff4A4A4A), fontSize: 16.0),
              ),
            ),
          ),
          onTap: () async{
            RouteGenerator.navigateToStory('privacy', isMemberCheck: false);
          }
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Container(
              width: width,
              child: Text(
                '服務條款',
                style: TextStyle(color: Color(0xff4A4A4A), fontSize: 16.0),
              ),
            ),
          ),
          onTap: () {
            RouteGenerator.navigateToStory('service-rule', isMemberCheck: false);
          }
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: AppVersionWidget()
        ),
      ]
    );
  }
}
