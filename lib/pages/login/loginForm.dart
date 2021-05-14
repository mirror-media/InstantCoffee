import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/login/bloc.dart';
import 'package:readr_app/blocs/login/events.dart';
import 'package:readr_app/blocs/login/states.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/widgets/memberLoginPolicy.dart';

class LoginForm extends StatefulWidget {
  final LoginState state;
  final String routeName;
  final Object routeArguments;
  LoginForm({
    @required this.state,
    this.routeName = RouteGenerator.magazine,
    this.routeArguments,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  _signInWithGoogle(String routeName, Object routeArguments) async {
    context.read<LoginBloc>().add(
      SignInWithGoogle(
        context,
        routeName: routeName, routeArguments: routeArguments
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
        if(!(widget.state is GoogleLoading))
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: _thirdPartyLoginButton(
                'assets/image/google_icon.png',
                '使用 Google 登入',
                state is LoginInitState
                ? () => _signInWithGoogle(widget.routeName, widget.routeArguments)
                : null,
              ),
            ),
          ),
        if(widget.state is GoogleLoading)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: _thirdPartyLoadingButton(),
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
}