import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/login/login_controller.dart';
import 'package:readr_app/widgets/member_login_policy.dart';

class LoginForm extends StatefulWidget {
  final LoginState state;

  const LoginForm({
    required this.state,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  LoginController? controller;

  @override
  void initState() {
    if (!Get.isRegistered<LoginController>()) {
      Get.put(LoginController());
    }
    controller = Get.find<LoginController>();
  }

  _signInWithGoogle() async {
    context.read<LoginBloc>().add(SignInWithGoogle());
  }

  _signInWithFacebook() async {
    context.read<LoginBloc>().add(SignInWithFacebook());
  }

  _signInWithApple() async {
    context.read<LoginBloc>().add(SignInWithApple());
  }

  _fetchSignInMethodsForEmail(String email) async {
    context.read<LoginBloc>().add(FetchSignInMethodsForEmail(email));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        _loginStandardWidget(
          width,
          widget.state,
        ),
        Obx(() {
          final isLoading = controller!.rxIsLoading.value;
          return isLoading
              ? Container(
                  width: Get.width,
                  height: Get.height,
                  color: Colors.grey.withAlpha(125),
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: appColor,
                  )))
              : const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _loginStandardWidget(
    double width,
    LoginState state,
  ) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 72)),
        const SliverToBoxAdapter(
          child: Center(
            child: Text(
              '會員登入',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        _thirdPartyLoginBlock(state),
        if (widget.state is RegisteredByAnotherMethod)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child:
                  _loginWarningText(widget.state as RegisteredByAnotherMethod),
            ),
          ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _dividerBlock(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _emailTextField(width,
                isEnabled: widget.state is LoginInitState),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        if (widget.state is! FetchSignInMethodsForEmailLoading)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: _emailLoginButton(),
            ),
          ),
        if (Platform.isIOS)
          SliverToBoxAdapter(
              child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              InkWell(
                onTap: controller?.anonymousLogin,
                child: const Text(
                  '以訪客模式使用',
                  style: TextStyle(
                      color: Color(0xFF1D9FB8),
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          )),
        if (widget.state is FetchSignInMethodsForEmailLoading)
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
                child: SizedBox(height: 50, child: MemberLoginPolicy()),
              )),
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
                : _googleLoginButton(isActive: isLoginInitState)),
        const SizedBox(height: 16),
        Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child:
                state is LoginLoading && state.loginType == LoginType.facebook
                    ? _thirdPartyLoadingButton()
                    : _facebookLoginButton(isActive: isLoginInitState)),
        const SizedBox(height: 16),
        if (Platform.isIOS) ...[
          Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: state is LoginLoading && state.loginType == LoginType.apple
                  ? _thirdPartyLoadingButton()
                  : _appleLoginButton(isActive: isLoginInitState)),
          const SizedBox(height: 16),
        ],
      ]),
    );
  }

  Widget _googleLoginButton({bool isActive = true}) {
    return _thirdPartyLoginButton(
      'assets/image/google_icon.png',
      '使用 Google 登入',
      isActive ? () => _signInWithGoogle() : null,
    );
  }

  Widget _facebookLoginButton({bool isActive = true}) {
    return _thirdPartyLoginButton(
      'assets/image/facebook_icon.png',
      '使用 Facebook 登入',
      isActive ? () => _signInWithFacebook() : null,
    );
  }

  Widget _appleLoginButton({bool isActive = true}) {
    return _thirdPartyLoginButton(
      'assets/image/apple_icon.png',
      '使用 Apple 登入',
      isActive ? () => _signInWithApple() : null,
    );
  }

  Widget _thirdPartyLoginButton(
      String imageLocation, String contentText, Function()? ontapFunction) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      onTap: ontapFunction,
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
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
            Container(),
          ],
        ),
      ),
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
      child: const SpinKitThreeBounce(
        color: Colors.grey,
        size: 35,
      ),
    );
  }

  Widget _loginWarningText(RegisteredByAnotherMethod state) {
    return Text(
      state.warningMessage,
      style: const TextStyle(
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
              child: const Divider(
                color: Colors.black,
                height: 50,
              )),
        ),
        const Text("或"),
        Expanded(
          child: Container(
              margin: const EdgeInsets.only(left: 15.0),
              child: const Divider(
                color: Colors.black,
                height: 50,
              )),
        ),
      ],
    );
  }

  String? validateEmail(String? value) {
    RegExp regex = RegExp(validEmailPattern);
    if (value == null || !regex.hasMatch(value)) {
      return 'Email 格式填寫錯誤';
    } else {
      return null;
    }
  }

  Widget _emailTextField(double width, {bool isEnabled = true}) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        enabled: isEnabled,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        validator: validateEmail,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
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
          child: const Center(
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
          if (_formKey.currentState!.validate()) {
            _fetchSignInMethodsForEmail(_email);
          }
        });
  }

  Widget _emailLoadingButton() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: const SpinKitThreeBounce(
        color: Colors.white,
        size: 35,
      ),
    );
  }
}
