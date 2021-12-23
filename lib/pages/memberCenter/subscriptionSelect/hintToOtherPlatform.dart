import 'package:flutter/material.dart';
import 'package:readr_app/models/paymentRecord.dart';

class HintToOtherPlatform extends StatelessWidget {
  final PaymentType paymentType;
  HintToOtherPlatform({
    @required this.paymentType,
  });
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('請至${paymentType.name}平台更動')
    );
  }
}