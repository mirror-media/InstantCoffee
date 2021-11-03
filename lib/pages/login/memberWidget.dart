import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/memberCenter/memberDetail/memberDetailCubit.dart';
import 'package:readr_app/blocs/memberCenter/paymentRecord/paymentRecordBloc.dart';
import 'package:readr_app/blocs/memberCenter/subscribedArticles/subscribedArticlesCubit.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';
import 'package:readr_app/pages/memberCenter/paymentRecord/memberPaymentRecordPage.dart';
import 'package:readr_app/pages/memberCenter/subscribedArticle/memberSubscribedArticlePage.dart';
import 'package:readr_app/pages/memberCenter/subscriptionDetail/memberSubscriptionDetailPage.dart';
import 'package:readr_app/pages/shared/memberSubscriptionTypeTitleWidget.dart';
import 'package:readr_app/services/emailSignInService.dart';
import 'package:readr_app/services/loginService.dart';

class MemberWidget extends StatefulWidget {
  final String israfelId;
  final SubscritionType subscritionType;
  MemberWidget({
    @required this.israfelId,
    @required this.subscritionType,
  });

  @override
  _MemberWidgetState createState() => _MemberWidgetState();
}

class _MemberWidgetState extends State<MemberWidget> {
  _showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

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
                _memberLevelBlock(widget.subscritionType),
                SizedBox(height: 24),
              ],
            ),
          ),
          if(widget.subscritionType != SubscritionType.staff)
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _horizontalDivider(width),
                  _memberSubscriptionDetailButton(widget.subscritionType),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                    child: _horizontalDivider(width),
                  ),
                  if(widget.subscritionType == SubscritionType.none || 
                    widget.subscritionType == SubscritionType.subscribe_one_time
                  )...[
                    _memberSubscribedArticleButton(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                      child: _horizontalDivider(width),
                    ),
                  ],
                  _memberPaymentRecordButton(widget.subscritionType),
                  if(widget.subscritionType != SubscritionType.marketing)...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                      child: _horizontalDivider(width),
                    ),
                    _subscriptionSelectButton(widget.subscritionType),
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

  Widget _memberLevelBlock(SubscritionType subscritionType) {
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
            subscritionType: subscritionType,
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

  Widget _memberSubscriptionDetailButton(SubscritionType subscritionType) {
    return _navigateButton(
      '我的方案細節',
      () => Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return BlocProvider(
              child: MemberSubscriptionDetailPage(subscritionType: subscritionType,),
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

  Widget _memberPaymentRecordButton(SubscritionType subscritionType) {
    return _navigateButton(
      '付款紀錄',
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context){
          return BlocProvider(
            create: (BuildContext context) => PaymentRecordBloc(),
            child: MemberPaymentRecordPage(subscritionType),
            );
          }
        )
      ),
    );
  }
 
  Widget _subscriptionSelectButton(SubscritionType subscritionType) {
    String buttonText = subscritionType == SubscritionType.none || subscritionType == SubscritionType.subscribe_one_time
      ? '升級 Premium 會員'
      : "變更方案";
    return _navigateButton(
      buttonText,
      () => RouteGenerator.navigateToSubscriptionSelect(subscritionType),
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
      () async{
        PasswordUpdateBloc passwordUpdateBloc = PasswordUpdateBloc(emailSignInRepos: EmailSignInServices());
        await RouteGenerator.navigateToPasswordUpdate(
          passwordUpdateBloc,
        );

        bool updateSuccess = passwordUpdateBloc.passwordUpdateSuccess;
        if(updateSuccess!= null && updateSuccess) {
          _signOut();
        }
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
        widget.subscritionType
      )
    );
  }
}
