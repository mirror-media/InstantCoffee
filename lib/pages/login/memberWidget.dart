import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/memberCenter/memberDetail/memberDetailCubit.dart';
import 'package:readr_app/blocs/memberCenter/paymentRecord/paymentRecordBloc.dart';
import 'package:readr_app/blocs/memberCenter/subscribedArticles/subscribedArticlesCubit.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/pages/memberCenter/paymentRecord/memberPaymentRecordPage.dart';
import 'package:readr_app/pages/memberCenter/subscribedArticle/memberSubscribedArticlePage.dart';
import 'package:readr_app/pages/memberCenter/subscriptionDetail/memberSubscriptionDetailPage.dart';
import 'package:readr_app/pages/passwordUpdate/passwordUpdatePage.dart';
import 'package:readr_app/pages/shared/memberSubscriptionTypeTitleWidget.dart';
import 'package:readr_app/services/loginService.dart';

class MemberWidget extends StatefulWidget {
  final String israfelId;
  final SubscriptionType subscriptionType;
  final bool isNewebpay;
  MemberWidget({
    required this.israfelId,
    required this.subscriptionType,
    required this.isNewebpay,
  });

  @override
  _MemberWidgetState createState() => _MemberWidgetState();
}

class _MemberWidgetState extends State<MemberWidget> {
  _signOut() async {
    context.read<LoginBloc>().add(SignOut());
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.grey[300],
      child: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 48),
                _memberLevelBlock(widget.subscriptionType),
                SizedBox(height: 24),
              ],
            ),
          ),
          if(widget.subscriptionType != SubscriptionType.staff)
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _horizontalDivider(width),
                  _memberSubscriptionDetailButton(widget.subscriptionType),
                  if(widget.subscriptionType == SubscriptionType.none || 
                    widget.subscriptionType == SubscriptionType.subscribe_one_time
                  )...[
                    Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                    child: _horizontalDivider(width),
                  ),
                    _memberSubscribedArticleButton(),
                  ],
                  if(widget.subscriptionType != SubscriptionType.marketing && 
                    widget.subscriptionType != SubscriptionType.subscribe_group
                  )...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                      child: _horizontalDivider(width),
                    ),
                    _memberPaymentRecordButton(widget.subscriptionType),
                    if(widget.subscriptionType == SubscriptionType.none ||
                      widget.subscriptionType == SubscriptionType.subscribe_one_time
                    )...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                        child: _horizontalDivider(width),
                      ),
                      _subscriptionSelectButton(widget.subscriptionType),
                    ]
                  ],
                ],
              ),
            ),
          SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '會員檔案',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _memberProfileButton(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: _horizontalDivider(width),
                ),
                if (LoginServices.checkIsEmailAndPasswordLogin()) ...[
                  _changePasswordButton(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                    child: _horizontalDivider(width),
                  ),
                ],
                _memberContactInfoButton(),
              ],
            ),
          ),
          SizedBox(height: 48),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _logoutButton(width),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: _horizontalDivider(width),
                ),
                _deleteMemberButton(width),
              ],
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
            style: TextStyle(fontSize: 15, color: appColor),
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: MemberSubscriptionTypeTitleWiget(
            subscriptionType: subscriptionType,
            fontSize: 20,
          ),
        ),
      ]
    );
  }

  Widget _horizontalDivider(double width) {
    return Container(
      color: Colors.grey,
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

  Widget _memberSubscribedArticleButton() {
    return _navigateButton(
      '訂閱中的文章',
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return BlocProvider(
            create: (BuildContext context) => SubscribedArticlesCubit(),
            child: MemberSubscribedArticlePage(),
            );
        })
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
 
  Widget _subscriptionSelectButton(SubscriptionType subscriptionType) {
    return _navigateButton(
      '升級 Premium 會員',
      () => RouteGenerator.navigateToSubscriptionSelect(),
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<LoginBloc>(context),
              child: PasswordUpdatePage(),
            ),
          ),
        );
      },
    );
  }

  Widget _memberContactInfoButton() {
    return _navigateButton(
      '聯絡資訊',
      () => RouteGenerator.navigateToEditMemberContactInfo(),
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
}
