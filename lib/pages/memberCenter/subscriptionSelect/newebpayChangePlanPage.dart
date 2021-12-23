import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class NewebpayChangePlanPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    String titleText = '變更方案';
    String hintText = '想要變更方案嗎？\n由於您先前於網頁版購買，如要變更方案，請至鏡週刊網頁操作。';
    
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