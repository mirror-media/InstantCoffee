import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/loginBLoc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/loginResponse.dart';
import 'package:readr_app/models/member.dart';
import 'package:readr_app/widgets/emailVerifyErrorWidget.dart';
import 'package:readr_app/widgets/fillInEmailLoginWidget.dart';
import 'package:readr_app/widgets/loginErrorWidget.dart';
import 'package:readr_app/widgets/memberWidget.dart';
import 'package:readr_app/widgets/receiveEmailNotificationWidget.dart';
import 'package:readr_app/widgets/verifyEmailLoginWidget.dart';

class MemberPage extends StatefulWidget {
  final bool isEmailLoginAuth;
  final String emailLink;
  MemberPage({
    this.isEmailLoginAuth = false,
    this.emailLink,
  });

  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  LoginBloc _loginBloc;
  final _formKey = GlobalKey<FormState>();
  String _email;

  @override
  void initState() {
    _loginBloc = LoginBloc(widget.isEmailLoginAuth, widget.emailLink);
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
                  emailLoginFunction: () {
                    if (_formKey.currentState.validate()) {
                      _loginBloc.loginByEmail(_email);
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
              
              case Status.EmailLoading:
                if(widget.isEmailLoginAuth) {
                  return VerifyEmailLoginWidget();
                }

                return _loginStandardWidget(
                  width,
                  Status.EmailLoading,
                );
                break;

              case Status.EmailLinkGetting:
                return ReceiveEmailNotificationWidget(
                  email: _email,
                );
                break;

              case Status.EmailFillingIn:
                return FillInEmailLoginWidget(
                  loginBloc: _loginBloc,
                  emailLink: snapshot.data.data.verifyEmailLink,
                );
                break;
              
              case Status.Completed:
                return MemberWidget(
                  loginBloc: _loginBloc,
                  member: snapshot.data.data,
                );
                break;

              case Status.EmailVerifyError:
                return EmailVerifyErrorWidget();
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
      return 'Enter a valid email address';
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
            labelText: '以email登入',
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
            '登入',
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
              '使用 Facebook 帳號登入', 
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
              '使用 Google 帳號登入', 
              googleLoginFunction
            ),
          ),
        if(status == Status.GoogleLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _thirdPartyLoadingButton(),
          ),
        SizedBox(height: 16),
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
        if(status != Status.EmailLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _emailLoginButton(emailLoginFunction),
          ),
        if(status == Status.EmailLoading)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _emailLoadingButton(),
          ),
      ],
    );
  }
}