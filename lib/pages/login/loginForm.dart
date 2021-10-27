import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/widgets/memberLoginPolicy.dart';

class LoginForm extends StatefulWidget {
  final LoginState state;
  LoginForm({
    @required this.state,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';

  _signInWithGoogle() async {
    context.read<LoginBloc>().add(
      SignInWithGoogle(
        context,
      )
    );
  }

  _signInWithFacebook() async {
    context.read<LoginBloc>().add(
      SignInWithFacebook(
        context,
      )
    );
  }

  _signInWithApple() async {
    context.read<LoginBloc>().add(
      SignInWithApple(
        context,
      )
    );
  }

  _fetchSignInMethodsForEmail(String email) async {
    context.read<LoginBloc>().add(
      FetchSignInMethodsForEmail(
        context,
        email
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return _loginStandardWidget(
      width,
      widget.state,
    );
  }

  Widget _loginStandardWidget(
    double width,
    LoginState state,
  ) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 72)),
        SliverToBoxAdapter(
          child: Center(
            child: Text(
              '會員登入',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        _thirdPartyLoginBlock(state),
        if(widget.state is RegisteredByAnotherMethod)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: _loginWarningText(widget.state),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _dividerBlock(),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _emailTextField(width, isEnabled: widget.state is LoginInitState),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        if(!(widget.state is FetchSignInMethodsForEmailLoading))
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: _emailLoginButton(),
            ),
          ),
        if(widget.state is FetchSignInMethodsForEmailLoading)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: _emailLoadingButton(),
            ),
          ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 44.0),
              child: Container(height: 50, child: MemberLoginPolicy()),
            )
          ),
        ),
      ],
    );
  }


  Widget _thirdPartyLoginBlock(LoginState state) {
    bool isLoginInitState = state is LoginInitState;

    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: state is LoginLoading && state.loginType == LoginType.google
          ? _thirdPartyLoadingButton()
          : _googleLoginButton(isActive: isLoginInitState)
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: state is LoginLoading && state.loginType == LoginType.facebook
          ? _thirdPartyLoadingButton()
          : _facebookLoginButton(isActive: isLoginInitState)
        ),
        SizedBox(height: 16),
        if(Platform.isIOS)
        ...[
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: state is LoginLoading && state.loginType == LoginType.apple
            ? _thirdPartyLoadingButton()
            : _appleLoginButton(isActive: isLoginInitState)
          ),
          SizedBox(height: 16),
        ],
      ]),
    );
  }

  Widget _googleLoginButton({bool isActive = true}) {
    return _thirdPartyLoginButton(
      'assets/image/google_icon.png',
      '使用 Google 登入',
      isActive
      ? () => _signInWithGoogle()
      : null,
    );
  }

  Widget _facebookLoginButton({bool isActive = true}) {
    return _thirdPartyLoginButton(
      'assets/image/facebook_icon.png',
      '使用 Facebook 登入',
      isActive
      ? () => _signInWithFacebook()
      : null,
    );  
  }

  Widget _appleLoginButton({bool isActive = true}) {
    return _thirdPartyLoginButton(
      'assets/image/apple_icon.png', 
      '使用 Apple 登入', 
      isActive
      ? () => _signInWithApple()
      : null,
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

  Widget _loginWarningText(RegisteredByAnotherMethod state) {
    return Text(
      state.warningMessage,
      style: TextStyle(
        color: Colors.red,
        fontSize: 16,
      ),
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
    return Form(
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
    );
  }

  Widget _emailLoginButton() {
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
      onTap: () {
        if (_formKey.currentState.validate()) {
          _fetchSignInMethodsForEmail(_email);
        }
      }
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
}