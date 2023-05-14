import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/helpers/data_constants.dart';
import 'package:readr_app/helpers/paragraph_format.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/models/story.dart';

class TermsOfServiceWidget extends StatefulWidget {
  final Story story;
  const TermsOfServiceWidget({
    required this.story,
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
      backgroundColor: _isAgreeTerms ? appColor : const Color(0xffE3E3E3),
      padding: const EdgeInsets.only(top: 12, bottom: 12),
    );

    return Column(
      children: [
        const SizedBox(height: 48),
        const Text('服務條款', style: TextStyle(fontSize: 28)),
        const SizedBox(height: 24),
        const Text('歡迎加入鏡週刊會員！繼續使用前，請先詳閱鏡週刊服務條款。',
            style: TextStyle(
              fontSize: 17,
            )),
        const SizedBox(height: 24),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(0.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Scrollbar(
                child: ListView(
              children: [
                _buildContent(widget.story),
              ],
            )),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: _isAgreeTerms,
              onChanged: (value) {
                setState(() {
                  _isAgreeTerms = value ?? false;
                });
              },
            ),
            const Text(
              '我同意以上條款',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextButton(
          style: flatButtonStyle,
          onPressed: _isAgreeTerms
              ? () async {
                  if (await _storage.ready) {
                    _storage.setItem("isAcceptTerms", true);
                  }

                  Navigator.of(context).pop();
                }
              : null,
          child: SizedBox(
            width: width * 2 / 3,
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
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  _buildContent(Story story) {
    ParagraphFormat paragraphFormat = ParagraphFormat();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: story.apiDatas.length,
          itemBuilder: (context, index) {
            Paragraph paragraph = story.apiDatas[index];
            if (paragraph.contents.isNotEmpty &&
                paragraph.contents[0].data != '') {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: paragraphFormat.parseTheParagraph(
                    paragraph, context, story.imageUrlList,
                    htmlFontSize: 13),
              );
            }
            return Container();
          }),
    );
  }
}
