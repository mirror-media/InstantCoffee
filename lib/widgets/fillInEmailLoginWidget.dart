import 'package:flutter/material.dart';
import 'package:readr_app/blocs/loginBLoc.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/loginResponse.dart';

class FillInEmailLoginWidget extends StatefulWidget {
  final LoginBloc loginBloc;
  final String emailLink;
  FillInEmailLoginWidget({
    @required this.loginBloc,
    @required this.emailLink,
  });

  @override
  _FillInEmailLoginWidgetState createState() => _FillInEmailLoginWidgetState();
}

class _FillInEmailLoginWidgetState extends State<FillInEmailLoginWidget> {
  final _formKey = GlobalKey<FormState>();
  String _email;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        SizedBox(height: 72),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              '以Email進行登入',
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _emailTextField(width),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0),
          child: _emailLoginButton(
            () {
              if (_formKey.currentState.validate()) {
                widget.loginBloc.loginSinkToAdd(LoginResponse.emailLoading('Verify email login'));
                widget.loginBloc.verifyEmail(_email, widget.emailLink);
              }
            },
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
}