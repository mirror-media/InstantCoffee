import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:readr_app/blocs/passwordUpdate/bloc.dart';
import 'package:readr_app/blocs/passwordUpdate/events.dart';
import 'package:readr_app/blocs/passwordUpdate/states.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/pages/shared/passwordValidatorWidget.dart';

class OldPasswordConfirmForm extends StatefulWidget {
  final OldPasswordConfirm oldPasswordConfirm;
  OldPasswordConfirmForm({
    @required this.oldPasswordConfirm,
  });

  _OldPasswordConfirmFormState createState() => _OldPasswordConfirmFormState();
}

class _OldPasswordConfirmFormState extends State<OldPasswordConfirmForm> {
  final _passwordEditingController = TextEditingController();
  bool _isHidden = true;
  bool _passwordIsValid = false;

  @override
  void initState() {
    _passwordEditingController.addListener(
      () {
        setState(() {
          _passwordIsValid = _isPasswordValid();
        });
      }
    );
    super.initState();
  }

  _confirmOldPassword(String oldPassword) async {
    context.read<PasswordUpdateBloc>().add(
      ConfirmOldPassword(oldPassword: oldPassword)
    );
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
  void dispose() {
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: Text(
            '請先輸入您目前的密碼，以進行後續操作。',
            style: TextStyle(
              color:  Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _passwordField(),
        ),
        SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: PasswordValidatorWidget(editingController: _passwordEditingController,),
        ),
        SizedBox(height: 24),
        if(widget.oldPasswordConfirm is OldPasswordConfirmFail)
        ...[
          Center(
            child: Text(
              '密碼錯誤，請重新再試',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red
              ),
            ),
          ),
          SizedBox(height: 12),
        ],
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: widget.oldPasswordConfirm is OldPasswordConfirmLoading
          ? _confirmPasswordLoadingButton()
          : _confirmPasswordButton(_passwordIsValid),
        ),
        SizedBox(height: 24),
      ],
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
          labelText: '目前的密碼',
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
  
  Widget _confirmPasswordLoadingButton() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: appColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: SpinKitThreeBounce(color: Colors.white, size: 35,),
    );
  }
  
  Widget _confirmPasswordButton(bool emailAndPasswordIsValid) {
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
            '下一步',
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
      ? () {
          _confirmOldPassword(
            _passwordEditingController.text
          );
        }
      : null
    );
  }
}