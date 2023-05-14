import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/memberCenter/memberDetail/member_detail_cubit.dart';
import 'package:readr_app/blocs/memberCenter/paymentRecord/payment_record_bloc.dart';
import 'package:readr_app/blocs/memberCenter/subscribedArticles/subscribed_articles_cubit.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/route_generator.dart';
import 'package:readr_app/models/member_subscription_type.dart';
import 'package:readr_app/pages/memberCenter/paymentRecord/member_payment_record_page.dart';
import 'package:readr_app/pages/memberCenter/subscribedArticle/member_subscribed_article_page.dart';
import 'package:readr_app/pages/memberCenter/subscriptionDetail/member_subscription_detail_page.dart';
import 'package:readr_app/pages/passwordUpdate/password_update_page.dart';
import 'package:readr_app/pages/shared/member_subscription_type_title_widget.dart';
import 'package:readr_app/services/login_service.dart';

class MemberWidget extends StatefulWidget {
  final String israfelId;
  final SubscriptionType subscriptionType;
  final bool isNewebpay;
  const MemberWidget({
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
                const SizedBox(height: 48),
                _memberLevelBlock(widget.subscriptionType),
                const SizedBox(height: 24),
              ],
            ),
          ),
          if (widget.subscriptionType != SubscriptionType.staff)
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _horizontalDivider(width),
                  _memberSubscriptionDetailButton(widget.subscriptionType),
                  if (widget.subscriptionType == SubscriptionType.none ||
                      widget.subscriptionType ==
                          SubscriptionType.subscribe_one_time) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                      child: _horizontalDivider(width),
                    ),
                    _memberSubscribedArticleButton(),
                  ],
                  if (widget.subscriptionType != SubscriptionType.marketing &&
                      widget.subscriptionType !=
                          SubscriptionType.subscribe_group) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                      child: _horizontalDivider(width),
                    ),
                    _memberPaymentRecordButton(widget.subscriptionType),
                    if (widget.subscriptionType == SubscriptionType.none ||
                        widget.subscriptionType ==
                            SubscriptionType.subscribe_one_time) ...[
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                        child: _horizontalDivider(width),
                      ),
                      _subscriptionSelectButton(widget.subscriptionType),
                    ]
                  ],
                ],
              ),
            ),
          const SizedBox(height: 36),
          const Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '會員檔案',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 48),
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: Text(
          '我的會員等級',
          style: TextStyle(fontSize: 15, color: appColor),
        ),
      ),
      const SizedBox(height: 4),
      Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: MemberSubscriptionTypeTitleWiget(
          subscriptionType: subscriptionType,
          textStyle: const TextStyle(fontSize: 20),
        ),
      ),
    ]);
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
      () => Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BlocProvider(
            child: MemberSubscriptionDetailPage(
              subscriptionType: subscriptionType,
            ),
            create: (BuildContext context) => MemberDetailCubit());
      })),
    );
  }

  Widget _memberSubscribedArticleButton() {
    return _navigateButton(
      '訂閱中的文章',
      () => Navigator.push(context, MaterialPageRoute(builder: (context) {
        return BlocProvider(
          create: (BuildContext context) => SubscribedArticlesCubit(),
          child: MemberSubscribedArticlePage(),
        );
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
              child: const PasswordUpdatePage(),
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
}
