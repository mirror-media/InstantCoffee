import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/memberSubscriptionType.dart';

class HintToWebsitePage extends StatelessWidget {
  final SubscritionType subscritionType;
  HintToWebsitePage(this.subscritionType);
  @override
  Widget build(BuildContext context) {
    String hintText;
    String titleText;
    if(subscritionType == SubscritionType.subscribe_one_time){
      titleText = '升級會員';
      hintText = '若欲升級 Premium 會員，請至網頁版進行操作。\nAPP 升級功能將於近期上線。';
    }
    else{
      titleText = '變更方案';
      hintText = '若欲變更會員訂閱方案，請至網頁版進行操作。\nAPP 變更方案功能將於近期上線。';
    }
    return Scaffold(
      appBar: _buildBar(context,titleText),
      body: Column(
        children: [
          SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            child: Center(
              child: Text(
                hintText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(BuildContext context, String titleText) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        titleText,
      ),
      backgroundColor: appColor,
    );
  }

}