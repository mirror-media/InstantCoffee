import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/loginBLoc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/loginResponse.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/widgets/loginErrorWidget.dart';
import 'package:readr_app/widgets/memberWidget.dart';

class MemberPage extends StatefulWidget {
  final String routeName;
  final Object routeArguments;
  MemberPage({
    this.routeName = RouteGenerator.magazine,
    this.routeArguments,
  });

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  LoginBloc _loginBloc;
  GlobalKey<FormState> _formKey;
  String _email;
  
  @override
  void initState() {
    _loginBloc = LoginBloc(
      widget.routeName,
      widget.routeArguments,
    );

    _formKey = GlobalKey<FormState>();
    _email = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: _buildBar(context),
      body: StreamBuilder<LoginResponse<Member>>(
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
                  facebookLoginFunction: () {
                    _loginBloc.loginByFacebook(context);
                  },
                  googleLoginFunction: () {
                    _loginBloc.loginByGoogle(context);
                  },
                  appleLoginFunction: () {
                    _loginBloc.loginByApple(context);
                  },
                  emailLoginFunction: () {
                    if (_formKey.currentState.validate()) {
                      _loginBloc.fetchSignInMethodsForEmail(_email);
                    }
                  },
                );
                break;
              
              case Status.FacebookLoading:
                return _loginStandardWidget(
                  width,
                  Status.FacebookLoading,
                );
                break;
              
              case Status.GoogleLoading:
                return _loginStandardWidget(
                  width,
                  Status.GoogleLoading,
                );
                break;

              case Status.AppleLoading:
                return _loginStandardWidget(
                  width,
                  Status.AppleLoading,
                );
                break;
              
              case Status.FetchSignInMethodsForEmailLoading:
                return _loginStandardWidget(
                  width,
                  Status.FetchSignInMethodsForEmailLoading,
                );
                break;
              
              case Status.Completed:
                return MemberWidget(
                  loginBloc: _loginBloc,
                  member: snapshot.data.data,
                );
                break;

              case Status.LoginError:
                return LoginErrorWidget();
                break;

              case Status.Error:
                return Container();
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: contentText.contains('Apple')
              ? const EdgeInsets.all(6.0)
              : const EdgeInsets.all(0),
              child: Image.asset(
                imageLocation,
              ),
            ),
            Text(
              contentText,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            Container(),
          ],
        ),
      ),
      onTap: ontapFunction,
    );
  }

  Widget _dividerBlock() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 15.0),
            child: Divider(
              color: Colors.black,
              height: 50,
            )
          ),
        ),
        Text("或"),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 15.0),
            child: Divider(
              color: Colors.black,
              height: 50,
            )
          ),
        ),
      ],
    );
  }

  String validateEmail(String value) {
    Pattern pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Email 格式填寫錯誤';
    else
      return null;
  }

  Widget _emailTextField(double width, {bool isEnabled = true}) {
    return Container(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          enabled: isEnabled,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          validator: validateEmail,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            labelText: '以 email 繼續',
            labelStyle: TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
            hintText: "name@example.com",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
          ),
          onChanged: (value) {
            _email = value;
          },
        ),
      ),
    );
  }

  Widget _emailLoginButton(Function ontapFunction) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: appColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            '下一步',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
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

  Widget _emailLoadingButton() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: SpinKitThreeBounce(color: Colors.white, size: 35,),
    );
  }

  Widget _loginStandardWidget(
    double width,
    Status status,
    {
      Function facebookLoginFunction,
      Function googleLoginFunction,
      Function appleLoginFunction,
      Function emailLoginFunction,
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
        if(status != Status.FacebookLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _thirdPartyLoginButton(
              'assets/image/facebook_icon.png', 
              '使用 Facebook 登入', 
              facebookLoginFunction,
            ),
          ),
        if(status == Status.FacebookLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _thirdPartyLoadingButton(),
          ),
        SizedBox(height: 16),
        if(status != Status.GoogleLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _thirdPartyLoginButton(
              'assets/image/google_icon.png', 
              '使用 Google 登入', 
              googleLoginFunction
            ),
          ),
        if(status == Status.GoogleLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _thirdPartyLoadingButton(),
          ),
        SizedBox(height: 16),
        if(Platform.isIOS)
        ...[
          if(status != Status.AppleLoading)
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: _thirdPartyLoginButton(
                'assets/image/apple_icon.png', 
                '使用 Apple 登入', 
                appleLoginFunction
              ),
            ),
          if(status == Status.AppleLoading)
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: _thirdPartyLoadingButton(),
            ),
          SizedBox(height: 16),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _dividerBlock(),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _emailTextField(width, isEnabled: status == Status.NeedToLogin),
        ),
        SizedBox(height: 16),
        if(status != Status.FetchSignInMethodsForEmailLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _emailLoginButton(emailLoginFunction),
          ),
        if(status == Status.FetchSignInMethodsForEmailLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _emailLoadingButton(),
          ),
      ],
    );
  }
}