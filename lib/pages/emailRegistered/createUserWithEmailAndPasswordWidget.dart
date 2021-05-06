import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/emailRegistered/bloc.dart';
import 'package:readr_app/blocs/emailRegistered/events.dart';
import 'package:readr_app/blocs/emailRegistered/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/emailRegistered/emailValidatorWidget.dart';
import 'package:readr_app/pages/emailRegistered/passwordValidatorWidget.dart';
import 'package:readr_app/widgets/memberLoginPolicy.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateUserWithEmailAndPasswordWidget extends StatefulWidget {
  final String email;
  CreateUserWithEmailAndPasswordWidget({
    @required this.email,
  });
    
  @override
  _CreateUserWithEmailAndPasswordWidgetState createState() => _CreateUserWithEmailAndPasswordWidgetState();
}

class _CreateUserWithEmailAndPasswordWidgetState extends State<CreateUserWithEmailAndPasswordWidget> {
  final _emailEditingController = TextEditingController();
  final _passwordEditingController = TextEditingController();
  bool _isHidden = true;
  bool _emailIsValid = false;
  bool _passwordIsValid = false;

  @override
  void initState() {
    _emailEditingController.text = widget.email;
    _emailIsValid = _isEmailValid();
    _emailEditingController.addListener(
      () {
        setState(() {
          _emailIsValid = _isEmailValid();
        });
      }
    );
    _passwordEditingController.addListener(
      () {
        setState(() {
          _passwordIsValid = _isPasswordValid();
        });
      }
    );
    super.initState();
  }

  bool _isEmailValid() {
    Pattern pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp regex = RegExp(pattern);
    return _emailEditingController.text != null && regex.hasMatch(_emailEditingController.text);
  }

  bool _isPasswordValid() {
    return _passwordEditingController.text != null && _passwordEditingController.text.length >= 6;
  }

  _createUserWithEmailAndPassword(String email, String password) async {
    context.read<EmailRegisteredBloc>().add(
      CreateUserWithEmailAndPassword(email: email, password: password)
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _delayNavigatorPop() async{
    await Future.delayed(Duration());
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<EmailRegisteredBloc, EmailRegisteredState>(
      builder: (BuildContext context, EmailRegisteredState state) {
        if (state is EmailRegisteredFail) {
          final error = state.error;
          print('EmailRegisteredFail: ${error.message}');
          return _errorWidget();
        }
        if (state is EmailRegisteredSuccess) {
          _delayNavigatorPop();
        }

        // state is Init, Loading, or EmailAlreadyInUse 
        return _buildEmailRegisteredBlock(state);
      }
    );
  }

  Widget _buildEmailRegisteredBlock(EmailRegisteredState state) {
    bool isLoading = state is EmailRegisteredLoading;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 56)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _emailTextField(),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: EmailValidatorWidget(editingController: _emailEditingController,),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 32)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _passwordField(),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: PasswordValidatorWidget(editingController: _passwordEditingController,),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24)),
        if(state is EmailAlreadyInUse)
        ...[
          SliverToBoxAdapter(
            child: Center(
              child: Text(
                '這個 Email 已經註冊過囉',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12)),
        ],
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: isLoading
            ? _emailLoadingButton()
            : _registerButton(_emailIsValid && _passwordIsValid),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24)),
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

  Widget _emailTextField() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        controller: _emailEditingController,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Form(
      child: TextFormField(
        controller: _passwordEditingController,
        obscureText: _isHidden,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () => _togglePasswordView(),
            icon: _isHidden 
            ? Icon(Icons.visibility)
            : Icon(Icons.visibility_off),
          ),
          labelText: '設定密碼',
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ),
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
  
  Widget _registerButton(bool emailAndPasswordIsValid) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: emailAndPasswordIsValid
          ? appColor
          : Color(0xffE3E3E3),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            '註冊會員',
            style: TextStyle(
              fontSize: 17,
              color: emailAndPasswordIsValid
              ? Colors.white
              : Colors.grey
            ),
          ),
        ),
      ),
      onTap: emailAndPasswordIsValid
      ? () async{
          _createUserWithEmailAndPassword(
            _emailEditingController.text, 
            _passwordEditingController.text
          );
        }
      : null
    );
  }

  Widget _errorWidget() {
    return ListView(
      children: [
        SizedBox(height: 48),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: Text(
              '抱歉，出了點狀況...',
              style: TextStyle(
                fontSize: 28
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Center(
            child: Text(
              '請重新嘗試註冊',
              style: TextStyle(
                fontSize: 28
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '或是聯繫客服信箱',
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: InkWell(
            child: Text(
              'mm-onlineservice@mirrormedia.mg',
              style: TextStyle(color: appColor, fontSize: 16.0),
            ),
            onTap: () async{
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'mm-onlineservice@mirrormedia.mg',
              );

              if (await canLaunch(emailLaunchUri.toString())) {
                await launch(emailLaunchUri.toString());
              } else {
                throw 'Could not launch mm-onlineservice@mirrormedia.mg';
              }
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '或致電 (02)6633-3966 由專人為您服務。',
            style: TextStyle(
              fontSize: 16
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _backButton(),
        ),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _backButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            '返回註冊',
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
        ),
      ),
      onTap: () => Navigator.of(context).pop()
    );
  }
}