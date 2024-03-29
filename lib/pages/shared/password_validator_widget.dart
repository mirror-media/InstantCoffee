import 'package:flutter/material.dart';

class PasswordValidatorWidget extends StatefulWidget {
  // need to be disposed by editing controller parent
  final TextEditingController editingController;
  const PasswordValidatorWidget({required this.editingController});

  @override
  _PasswordValidatorWidgetState createState() =>
      _PasswordValidatorWidgetState();
}

class _PasswordValidatorWidgetState extends State<PasswordValidatorWidget> {
  late TextEditingController _passwordEditingController;
  late Widget _passwordHint;

  @override
  void initState() {
    _passwordEditingController = widget.editingController;
    _setPasswordHint(_passwordEditingController.text);
    _passwordEditingController.addListener(() {
      if (_passwordEditingController.text.length < 6) {
        setState(() {
          _passwordHint = const Text(
            '密碼在 6 位數以上',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          );
        });
      } else {
        setState(() {
          _passwordHint = Row(
            children: const [
              Icon(
                Icons.check,
                color: Colors.green,
              ),
              SizedBox(width: 8),
              Text(
                '密碼在 6 位數以上',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ],
          );
        });
      }
    });
    super.initState();
  }

  _setPasswordHint(String text) {
    if (text.length < 6) {
      _passwordHint = const Text(
        '密碼在 6 位數以上',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      );
    } else {
      _passwordHint = Row(
        children: const [
          Icon(
            Icons.check,
            color: Colors.green,
          ),
          SizedBox(width: 8),
          Text(
            '密碼在 6 位數以上',
            style: TextStyle(color: Colors.green, fontSize: 16),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _passwordHint;
  }
}
