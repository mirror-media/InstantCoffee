import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/loginBLoc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/loginResponse.dart';
import 'package:readr_app/models/userData.dart';
import 'package:readr_app/widgets/loginErrorWidget.dart';
import 'package:readr_app/widgets/memberWidget.dart';

class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    _loginBloc = LoginBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildBar(context),
      body: StreamBuilder<LoginResponse<UserData>>(
        stream: _loginBloc.loginStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LoadingUI:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.NeedToLogin:
                return _loginStandardWidget(
                  width,
                  Status.NeedToLogin,
                  googleLoginFunction: () {
                    _loginBloc.loginByGoogle(context);
                  },
                );
                break;
              
              case Status.GoogleLoading:
                return _loginStandardWidget(
                  width,
                  Status.GoogleLoading,
                );
                break;
              
              case Status.Completed:
                return MemberWidget(
                  loginBloc: _loginBloc,
                  userData: snapshot.data.data,
                );
                break;

              case Status.Error:
                return LoginErrorWidget();
                break;
            }
          }
          return Container();
        },
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text('會員中心'),
      backgroundColor: appColor,
    );
  }

  Widget _thirdPartyLoginButton(String imageLocation, String contentText, Function ontapFunction) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(
            style: BorderStyle.solid,
            width: 1.0,
          ),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imageLocation,
            ),
            SizedBox(width: 4.0),
            Text(
              contentText,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
      onTap: ontapFunction,
    );
  }

  Widget _thirdPartyLoadingButton() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(
          style: BorderStyle.solid,
          width: 1.0,
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: SpinKitThreeBounce(color: Colors.grey, size: 35,),
    );
  }

  Widget _loginStandardWidget(
    double width,
    Status status,
    {
      Function googleLoginFunction,
    }
  ) {
    return ListView(
      children: [
        SizedBox(height: 72),
        Center(
          child: Text(
            '會員登入',
            style: TextStyle(
              fontSize: 28,
            ),
          ),
        ),
        SizedBox(height: 16),
        if(status != Status.GoogleLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _thirdPartyLoginButton(
              'assets/image/google_icon.png', 
              '使用 Google 帳號登入', 
              googleLoginFunction
            ),
          ),
        if(status == Status.GoogleLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _thirdPartyLoadingButton(),
          ),
      ],
    );
  }
}