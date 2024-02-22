import 'package:flutter/material.dart';
import 'package:readr_app/helpers/data_constants.dart';
class EmailValidatorWidget extends StatefulWidget {
  // need to be disposed by editing controller parent
  final TextEditingController editingController;
  const EmailValidatorWidget({required this.editingController});

  @override
  _EmailValidatorWidgetState createState() => _EmailValidatorWidgetState();
}

class _EmailValidatorWidgetState extends State<EmailValidatorWidget> {
  late TextEditingController _emailEditingController;
  late Widget _emailHint;

  @override
  void initState() {
    _emailEditingController = widget.editingController;
    RegExp regex = RegExp(validEmailPattern);
    _setEmailHint(_emailEditingController.text, regex);
    _emailEditingController.addListener(() {
      if (!regex.hasMatch(_emailEditingController.text)) {
        setState(() {
          _emailHint = const Text(
            'Email 格式正確',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          );
        });
      } else {
        setState(() {
          _emailHint = Row(
            children: const [
              Icon(
                Icons.check,
                color: Colors.green,
              ),
              SizedBox(width: 8),
              Text(
                'Email 格式正確',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
            ],
          );
        });
      }
    });
    super.initState();
  }

  _setEmailHint(String text, RegExp regex) {
    if (!regex.hasMatch(text)) {
      _emailHint = const Text(
        'Email 格式正確',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      );
    } else {
      _emailHint = Row(
        children: const [
          Icon(
            Icons.check,
            color: Colors.green,
          ),
          SizedBox(width: 8),
          Text(
            'Email 格式正確',
            style: TextStyle(color: Colors.green, fontSize: 16),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _emailHint;
  }
}
