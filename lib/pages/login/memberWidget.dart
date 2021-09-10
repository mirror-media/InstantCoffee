import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/memberCenter/editMemberContactInfo/bloc.dart';
import 'package:readr_app/blocs/memberCenter/editMemberProfile/bloc.dart';
import 'package:readr_app/blocs/memberDetail/cubit/memberdetail_cubit.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/pages/memberCenter/paymentRecord/memberPaymentRecordPage.dart';
import 'package:readr_app/pages/memberCenter/subscriptionArticle/memberSubscriptionArticlePage.dart';
import 'package:readr_app/pages/memberCenter/subscriptionDetail/memberSubscriptionDetailPage.dart';
import 'package:readr_app/pages/memberCenter/subscriptionSelect/subscriptionSelectPage.dart';
import 'package:readr_app/services/emailSignInService.dart';
import 'package:readr_app/services/loginService.dart';
import 'package:readr_app/services/memberService.dart';

class MemberWidget extends StatefulWidget {
  final Member member;
  MemberWidget({
    @required this.member,
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
    return _memberSection(width, widget.member);
  }

  _memberSection(
    double width, 
    Member member,
  ) {
    final ButtonStyle flatButtonStyle = ButtonStyle(
      overlayColor: MaterialStateProperty.all(Colors.grey[350]),
      padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),),
    );

    return Container(
      color: Colors.grey[300],
      child: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 48,),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Text(
                    '我的會員等級',
                    style: TextStyle(fontSize: 15, color: appColor),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Text(
                    'Basic 會員',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  color: Colors.grey,
                  width: width,
                  height: 1,
                ),
                _navigateButton(
                  '我的方案細節',
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    // Check user's member type
                    bool isPremium = true;
                    if (isPremium) {
                      return BlocProvider(
                          child: MemberSubscriptionDetailPage(),
                          create: (BuildContext context) =>
                              MemberdetailCubit());
                    } else {
                      return MemberSubscriptionDetailPage(
                        isPremium: isPremium,
                      );
                    }
                  })),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: Container(
                    color: Colors.grey,
                    width: width,
                    height: 1,
                  ),
                ),
                _navigateButton(
                  '訂閱中的文章',
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MemberSubscriptionArticlePage())),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: Container(
                    color: Colors.grey,
                    width: width,
                    height: 1,
                  ),
                ),
                _navigateButton(
                  '付款紀錄',
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MemberPaymentRecordPage())),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: Container(
                    color: Colors.grey,
                    width: width,
                    height: 1,
                  ),
                ),
                _navigateButton(
                  '升級 Premium 會員',
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubscriptionSelectPage())),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 36,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Text(
              '會員檔案',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _navigateButton(
                  '個人資料',
                  () async{
                    EditMemberProfileBloc editMemberProfileBloc = EditMemberProfileBloc(memberRepos: MemberService());
                    await RouteGenerator.navigateToEditMemberProfile(
                      context, 
                      editMemberProfileBloc
                    );

                    bool updateSuccess = editMemberProfileBloc.memberProfileUpdateSuccess;
                    if(updateSuccess!= null) {
                      if(updateSuccess) {
                        Fluttertoast.showToast(
                          msg: '儲存成功',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: '儲存失敗，請再試一次',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                      }
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: Container(
                    color: Colors.grey,
                    width: width,
                    height: 1,
                  ),
                ),
                if (LoginServices.checkIsEmailAndPasswordLogin()) ...[
                  _navigateButton(
                    '修改密碼',
                    () async{
                      PasswordUpdateBloc passwordUpdateBloc = PasswordUpdateBloc(emailSignInRepos: EmailSignInServices());
                      await RouteGenerator.navigateToPasswordUpdate(
                        context,
                        passwordUpdateBloc,
                      );

                      bool updateSuccess = passwordUpdateBloc.passwordUpdateSuccess;
                      if(updateSuccess!= null) {
                        if(updateSuccess) {
                          _signOut();
                        } else {
                          Fluttertoast.showToast(
                            msg: '更改密碼失敗',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                          );
                        }
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                    child: Container(
                      color: Colors.grey,
                      width: width,
                      height: 1,
                    ),
                  ),
                ],
                _navigateButton(
                  '聯絡資訊',
                  () async{
                    EditMemberContactInfoBloc editMemberContactInfoBloc = EditMemberContactInfoBloc(memberRepos: MemberService());
                    await RouteGenerator.navigateToEditMemberContactInfo(
                      context,
                      editMemberContactInfoBloc
                    );

                    bool updateSuccess = editMemberContactInfoBloc.memberContactInfoUpdateSuccess;
                    if(updateSuccess!= null) {
                      if(updateSuccess) {
                        Fluttertoast.showToast(
                          msg: '儲存成功',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: '儲存失敗，請再試一次',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 48,
          ),
          Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
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
                                onPressed: () async {
                                  _signOut();
                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  child: Container(
                    color: Colors.grey,
                    width: width,
                    height: 1,
                  ),
                ),
                InkWell(
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
                  onTap: () => RouteGenerator.navigateToDeleteMember(context)
                ),
              ],
            ),
          ),
        ],
      ),
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
}
