import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/emailRegistered/bloc.dart';
import 'package:readr_app/blocs/emailRegistered/events.dart';
import 'package:readr_app/blocs/emailRegistered/states.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/shared/email_validator_widget.dart';
import 'package:readr_app/pages/shared/password_form_field.dart';
import 'package:readr_app/pages/shared/password_validator_widget.dart';
import 'package:readr_app/widgets/member_login_policy.dart';

class EmailRegisteredForm extends StatefulWidget {
  final String email;
  final EmailRegisteredState state;
  final TextEditingController emailEditingController;
  final TextEditingController passwordEditingController;
  const EmailRegisteredForm({
    required this.email,
    required this.state,
    required this.emailEditingController,
    required this.passwordEditingController,
  });

  @override
  _EmailRegisteredFormState createState() => _EmailRegisteredFormState();
}

class _EmailRegisteredFormState extends State<EmailRegisteredForm> {
  late TextEditingController _emailEditingController;
  late TextEditingController _passwordEditingController;
  bool _emailIsValid = false;
  bool _passwordIsValid = false;

  @override
  void initState() {
    _emailEditingController = widget.emailEditingController;
    _passwordEditingController = widget.passwordEditingController;
    _emailEditingController.text = widget.email;
    _emailIsValid = _isEmailValid();
    _emailEditingController.addListener(() {
      setState(() {
        _emailIsValid = _isEmailValid();
      });
    });
    _passwordEditingController.addListener(() {
      setState(() {
        _passwordIsValid = _isPasswordValid();
      });
    });
    super.initState();
  }

  _createUserWithEmailAndPassword(String email, String password) async {
    context
        .read<EmailRegisteredBloc>()
        .add(CreateUserWithEmailAndPassword(email: email, password: password));
  }

  bool _isEmailValid() {
    String pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(_emailEditingController.text);
  }

  bool _isPasswordValid() {
    return _passwordEditingController.text.length >= 6;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 56)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _emailTextField(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: EmailValidatorWidget(
              editingController: _emailEditingController,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: PasswordFormField(
              title: '設定密碼',
              passwordEditingController: _passwordEditingController,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: PasswordValidatorWidget(
              editingController: _passwordEditingController,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        if (widget.state is EmailAlreadyInUse) ...[
          const SliverToBoxAdapter(
            child: Center(
              child: Text(
                '這個 Email 已經註冊過囉',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
        ],
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: widget.state is EmailRegisteredLoading
                ? _emailLoadingButton()
                : _registerButton(_emailIsValid && _passwordIsValid),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
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

  Widget _emailTextField() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: TextFormField(
        controller: _emailEditingController,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: const InputDecoration(
          labelText: 'Email',
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
      child: const SpinKitThreeBounce(
        color: Colors.white,
        size: 35,
      ),
    );
  }

  Widget _registerButton(bool emailAndPasswordIsValid) {
    return InkWell(
        borderRadius: BorderRadius.circular(5.0),
        onTap: emailAndPasswordIsValid
            ? () async {
                _createUserWithEmailAndPassword(_emailEditingController.text,
                    _passwordEditingController.text);
              }
            : null,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: emailAndPasswordIsValid ? appColor : const Color(0xffE3E3E3),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Text(
              '註冊會員',
              style: TextStyle(
                  fontSize: 17,
                  color: emailAndPasswordIsValid ? Colors.white : Colors.grey),
            ),
          ),
        ));
  }
}
