import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/events.dart';
import 'package:readr_app/blocs/passwordUpdate/states.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/pages/shared/password_form_field.dart';
import 'package:readr_app/pages/shared/password_validator_widget.dart';

class OldPasswordConfirmForm extends StatefulWidget {
  final OldPasswordConfirm oldPasswordConfirm;
  const OldPasswordConfirmForm({
    required this.oldPasswordConfirm,
  });

  @override
  _OldPasswordConfirmFormState createState() => _OldPasswordConfirmFormState();
}

class _OldPasswordConfirmFormState extends State<OldPasswordConfirmForm> {
  final _passwordEditingController = TextEditingController();
  bool _passwordIsValid = false;

  @override
  void initState() {
    _passwordEditingController.addListener(() {
      setState(() {
        _passwordIsValid = _isPasswordValid();
      });
    });
    super.initState();
  }

  _confirmOldPassword(String oldPassword) async {
    context
        .read<PasswordUpdateBloc>()
        .add(ConfirmOldPassword(oldPassword: oldPassword));
  }

  bool _isPasswordValid() {
    return _passwordEditingController.text.length >= 6;
  }

  @override
  void dispose() {
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '請先輸入您目前的密碼，以進行後續操作。',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: PasswordFormField(
            title: '目前的密碼',
            passwordEditingController: _passwordEditingController,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: PasswordValidatorWidget(
            editingController: _passwordEditingController,
          ),
        ),
        const SizedBox(height: 24),
        if (widget.oldPasswordConfirm is OldPasswordConfirmFail) ...[
          const Center(
            child: Text(
              '密碼錯誤，請重新再試',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: widget.oldPasswordConfirm is OldPasswordConfirmLoading
              ? _confirmPasswordLoadingButton()
              : _confirmPasswordButton(_passwordIsValid),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _confirmPasswordLoadingButton() {
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

  Widget _confirmPasswordButton(bool emailAndPasswordIsValid) {
    return InkWell(
        borderRadius: BorderRadius.circular(5.0),
        onTap: emailAndPasswordIsValid
            ? () {
                _confirmOldPassword(_passwordEditingController.text);
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
              '下一步',
              style: TextStyle(
                  fontSize: 17,
                  color: emailAndPasswordIsValid ? Colors.white : Colors.grey),
            ),
          ),
        ));
  }
}
