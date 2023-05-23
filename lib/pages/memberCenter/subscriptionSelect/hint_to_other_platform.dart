import 'package:flutter/material.dart';
import 'package:readr_app/models/payment_record.dart';

class HintToOtherPlatform extends StatelessWidget {
  final PaymentType paymentType;
  const HintToOtherPlatform({
    required this.paymentType,
  });

  @override
  Widget build(BuildContext context) {
    String hintText = '';
    if (paymentType == PaymentType.newebpay) {
      hintText = '由於您先前於鏡週刊網頁版購買，如要變更方案，請至鏡週刊網頁操作';
    } else if (paymentType == PaymentType.google_play) {
      hintText = '由於您先前於google paly 購買，如要變更方案，請至google paly 操作';
    } else if (paymentType == PaymentType.app_store) {
      hintText = '由於您先前於apple store 購買，如要變更方案，請至apple store 操作';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 0.0),
      child: Text(
        hintText,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }
}
