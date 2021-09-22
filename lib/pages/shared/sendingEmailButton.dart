import 'dart:async';

import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class SendingEmailButton extends StatefulWidget {
  final bool emailIsValid;
  final bool isWaiting;
  final GestureTapCallback onTap;
  final int waitingSeconds;

  SendingEmailButton({
    @required this.emailIsValid,
    @required this.isWaiting,
    @required this.onTap,
    this.waitingSeconds = 30,
  });

  @override
  _SendingEmailButtonState createState() => _SendingEmailButtonState();
}

class _SendingEmailButtonState extends State<SendingEmailButton> {
  bool _isWaiting;
  Timer _timer;

  @override
  void initState() {
    _isWaiting = widget.isWaiting;
    const oneSec = const Duration(seconds:1);
    _timer = Timer.periodic(
      oneSec, (Timer t) {
        if(widget.waitingSeconds == t.tick) {
          _timer.cancel();
          if(mounted) {
            setState(() {
              _isWaiting = false;
            });
          }
        }
        if(mounted) {
          setState(() {});
        }
      }
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.emailIsValid) {
      return InkWell(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Color(0xffE3E3E3),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Text(
              _isWaiting
              ? '重新寄送...(${widget.waitingSeconds - _timer.tick} 秒)'
              : widget.isWaiting
                ? '重新寄送'
                : '送出',
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: null
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: _isWaiting ? Color(0xffE3E3E3) : appColor,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(
            _isWaiting
            ? '重新寄送...(${widget.waitingSeconds - _timer.tick} 秒)'
            : widget.isWaiting
              ? '重新寄送'
              : '送出',
            style: TextStyle(
              fontSize: 17,
              color: _isWaiting
              ? Colors.grey[600]
              : Colors.white,
            ),
          ),
        ),
      ),
      onTap: _isWaiting
      ? null
      : widget.onTap,
    );
  }
}