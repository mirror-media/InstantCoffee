import 'package:flutter/material.dart';
import 'package:readr_app/core/values/colors.dart';

class ProhibitDeletingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: ListView(
        children: [
          const SizedBox(height: 48),
          const Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Center(
              child: Text(
                '目前無法刪除帳號',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            child: Center(
              child: Text(
                '由於您為 VIP / Premium 會員，如要刪除帳號，請於 VIP / 訂閱期限到期後操作。',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _backToHomeButton('回首頁', context),
          ),
          const SizedBox(height: 24),
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
            style: const TextStyle(
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
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: const Text('會員中心'),
      backgroundColor: appColor,
    );
  }
}
