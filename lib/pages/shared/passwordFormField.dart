import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final String title;
  final TextEditingController passwordEditingController;
  PasswordFormField({
    @required this.title,
    @required this.passwordEditingController,
  });

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        controller: widget.passwordEditingController,
        obscureText: _isHidden,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () => _togglePasswordView(),
            icon: _isHidden 
            ? Icon(Icons.visibility_off)
            : Icon(Icons.visibility),
          ),
          labelText: widget.title,
          labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}