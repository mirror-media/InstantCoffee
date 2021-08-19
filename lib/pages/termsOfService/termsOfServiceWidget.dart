import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/paragraphFormat.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/models/story.dart';

class TermsOfServiceWidget extends StatefulWidget {
  final Story story;
  TermsOfServiceWidget({
    @required this.story,
  });
  
  @override
  _TermsOfServiceWidgetState createState() => _TermsOfServiceWidgetState();
}

class _TermsOfServiceWidgetState extends State<TermsOfServiceWidget> {
  final LocalStorage _storage = LocalStorage('setting');
  bool _isAgreeTerms = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: _isAgreeTerms ? appColor : Color(0xffE3E3E3),
      padding: EdgeInsets.only(top: 12, bottom: 12),
    );

    return Column(
      children: [
        SizedBox(height: 48),
        Text(
          '服務條款',
          style: TextStyle(
            fontSize: 28
          )
        ),
        SizedBox(height: 24),
        Text(
          '歡迎加入鏡週刊會員！繼續使用前，請先詳閱鏡週刊服務條款。',
          style: TextStyle(
            fontSize: 17,
          )
        ),
        SizedBox(height: 24),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(0.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
            ),
            child: Scrollbar(
              child: ListView(
                children: [
                  _buildContent(widget.story),
                ],
              )
            ),
          ),
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: _isAgreeTerms,
              onChanged: (value) {
                setState(() {
                  _isAgreeTerms = value;
                });
              },
            ),
            Text(
              '我同意以上條款',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        TextButton(
          style: flatButtonStyle,
          child: Container(
            width: width*2/3,
            child: Center(
              child: Text(
                '開始使用',
                style: TextStyle(
                  fontSize: 17,
                  color: _isAgreeTerms ? Colors.white : Colors.black26,
                ),
              ),
            ),
          ),
          onPressed: _isAgreeTerms 
          ? () async{
            if(await _storage.ready) {
              _storage.setItem("isAcceptTerms", true);
            }
            
            Navigator.of(context).pop();
          }
          : null,
        ),
        SizedBox(height: 48),
      ],
    );
  }

  _buildContent(Story story) {
    ParagraphFormat paragraphFormat = ParagraphFormat();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: story.apiDatas.length,
        itemBuilder: (context, index) {
          Paragraph paragraph = story.apiDatas[index];
          if (paragraph.contents != null && 
              paragraph.contents.length > 0 &&
              paragraph.contents[0].data != '') {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: paragraphFormat.parseTheParagraph(paragraph, context),
            );
          }
          return Container();
        }
      ),
    );
  }
}