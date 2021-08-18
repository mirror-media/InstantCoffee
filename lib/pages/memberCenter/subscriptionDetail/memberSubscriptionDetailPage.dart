import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class MemberSubscriptionDetailPage extends StatefulWidget {
  @override
  _MemberSubscriptionDetailPageState createState() => _MemberSubscriptionDetailPageState();
}

class _MemberSubscriptionDetailPageState extends State<MemberSubscriptionDetailPage> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: _buildBar(context),
      body: ListView(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _memberRowContent('我的會員等級', 'Basic 會員'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
            child: Container(
              color: Colors.grey,
              width: width,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _memberRowContent('訂閱方案', '月訂閱'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
            child: Container(
              color: Colors.grey,
              width: width,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _memberRowContent('訂閱週期', '2021/7/1-2021/7/31'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
            child: Container(
              color: Colors.grey,
              width: width,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _memberRowContent('下次收費日', '2021/8/1'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
            child: Container(
              color: Colors.grey,
              width: width,
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: _memberRowContent('付款方式', '信用卡自動續扣（2924）'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
            child: Container(
              color: Colors.grey,
              width: width,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      centerTitle: true,
      title: Text(
        '我的方案細節',
      ),
      backgroundColor: appColor,
    );
  }

  Widget _memberRowContent(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: appColor
          ),
        ),
        SizedBox(height: 4,),
        Text(
          description,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ]
    );
  }
}