import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class ProhibitDeletingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: ListView(
        children: [
          SizedBox(height: 48),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Center(
              child: Text(
                '目前無法刪除帳號',
                style: TextStyle(
                  fontSize: 28
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Center(
              child: Text(
                '由於您為 VIP / Premium 會員，如要刪除帳號，請於 VIP / 訂閱期限到期後操作。',
                style: TextStyle(
                  fontSize: 17
                ),
              ),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _backToHomeButton('回首頁', context),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _backToHomeButton(String text, BuildContext context) {
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
            text,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
    );
  }

  PreferredSizeWidget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text('會員中心'),
      backgroundColor: appColor,
    );
  }
}