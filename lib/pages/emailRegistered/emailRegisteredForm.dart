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

class EmailRegisteredForm extends StatefulWidget {
  final String email;
  final EmailRegisteredState state;
  final TextEditingController emailEditingController;
  final TextEditingController passwordEditingController;
  EmailRegisteredForm({
    @required this.email,
    @required this.state,
    @required this.emailEditingController,
    @required this.passwordEditingController,
  });

  @override
  _EmailRegisteredFormState createState() => _EmailRegisteredFormState();
}

class _EmailRegisteredFormState extends State<EmailRegisteredForm> {
  TextEditingController _emailEditingController;
  TextEditingController _passwordEditingController;
  bool _isLoading;
  bool _isHidden = true;
  bool _emailIsValid = false;
  bool _passwordIsValid = false;

  @override
  void initState() {
    _emailEditingController = widget.emailEditingController;
    _passwordEditingController = widget.passwordEditingController;
    _emailEditingController.text = widget.email;
    _isLoading = widget.state is EmailRegisteredLoading;
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

  _createUserWithEmailAndPassword(String email, String password) async {
    context.read<EmailRegisteredBloc>().add(
      CreateUserWithEmailAndPassword(email: email, password: password)
    );
  }
  
  bool _isEmailValid() {
    Pattern pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp regex = RegExp(pattern);
    return _emailEditingController.text != null && regex.hasMatch(_emailEditingController.text);
  }

  bool _isPasswordValid() {
    return _passwordEditingController.text != null && _passwordEditingController.text.length >= 6;
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        if(widget.state is EmailAlreadyInUse)
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
            child: _isLoading
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
}