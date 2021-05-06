import 'package:flutter/material.dart';

class EmailValidatorWidget extends StatefulWidget {
  // need to be disposed by editing controller parent
  final TextEditingController editingController;
  EmailValidatorWidget({
    @required this.editingController
  });
  
  @override
  _EmailValidatorWidgetState createState() => _EmailValidatorWidgetState();
}

class _EmailValidatorWidgetState extends State<EmailValidatorWidget> {
  TextEditingController _emailEditingController;
  Widget _emailHint;

  @override
  void initState() {
    _emailEditingController = widget.editingController;
    Pattern pattern = r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$";
    RegExp regex = RegExp(pattern);
    _setEmailHint(_emailEditingController.text, regex); 
    _emailEditingController.addListener(
      () {
        if(_emailEditingController.text == null || !regex.hasMatch(_emailEditingController.text)) {
          setState(() {
            _emailHint = Text(
              'Email 格式正確',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16
              ),
            );
          });
        } else {
          setState(() {
            _emailHint = Row(
              children: [
                Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                Text(
                  'Email 格式正確',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16
                  ),
                ),
              ],
            );
          });
        }
      }
    );
    super.initState();
  }

  _setEmailHint(String text, RegExp regex) {
    if(text == null || !regex.hasMatch(text)) {
      _emailHint = Text(
        'Email 格式正確',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16
        ),
      );
    } else {
      _emailHint = Row(
        children: [
          Icon(
            Icons.check,
            color: Colors.green,
          ),
          SizedBox(width: 8),
          Text(
            'Email 格式正確',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16
            ),
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