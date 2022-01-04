import 'dart:math' as math;

import 'package:flutter_embedded_webview/flutter_embedded_webview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/material.dart';

import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/contentList.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/widgets/annotationWidget.dart';
import 'package:readr_app/widgets/imageAndDescriptionSlideShowWidget.dart';
import 'package:readr_app/widgets/imageDescriptionWidget.dart';
import 'package:readr_app/widgets/infoBoxWidget.dart';
import 'package:readr_app/widgets/mMAudioPlayer.dart';
import 'package:readr_app/widgets/mMVideoPlayer.dart';
import 'package:readr_app/widgets/quoteByWidget.dart';
import 'package:readr_app/widgets/youtubeWidget.dart';

class ParagraphFormat {
  bool _isMemberContent = false;
  Widget parseTheParagraph(
    Paragraph paragraph, 
    BuildContext context,
    List<String> imageUrlList, 
    {double htmlFontSize = 20, 
    bool isMemberContent = false,
    }) {
    _isMemberContent = isMemberContent;
    switch (paragraph.type) {
      case 'header-one':
        {
          if (paragraph.contents.length > 0) {
            return parseTheTextToHtmlWidget(
                '<h1>' + paragraph.contents[0].data + '</h1>', null, fontSize: htmlFontSize);
          }
          return Container();
        }
      case 'header-two':
        {
          if (paragraph.contents.length > 0) {
            return parseTheTextToHtmlWidget(
                '<h2>' + paragraph.contents[0].data + '</h2>', null, fontSize: htmlFontSize);
          }
          return Container();
        }
      case 'code-block':
      case 'unstyled':
        {
          if (paragraph.contents.length > 0) {
            return parseTheTextToHtmlWidget(paragraph.contents[0].data, null, fontSize: htmlFontSize);
          }
          return Container();
        }
      case 'blockquote':
        {
          if (paragraph.contents.length > 0) {
            Widget blockquote;
            if(_isMemberContent){
              blockquote = QuoteByWidget(
                quote: paragraph.contents[0].data,
                isMemberContent: _isMemberContent,
              );
              return _addPaddingIfNeeded(blockquote);
            }
            blockquote = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.rotate(
                  angle: 180 * math.pi / 180,
                  child: Icon(
                    Icons.format_quote,
                    size: 60,
                    color: appColor,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                    child: parseTheTextToHtmlWidget(
                        paragraph.contents[0].data, null, fontSize: htmlFontSize)),
                SizedBox(width: 8),
                Icon(
                  Icons.format_quote,
                  size: 60,
                  color: appColor,
                ),
              ],
            );
            return _addPaddingIfNeeded(blockquote);
          }
          return Container();
        }
        break;
      case 'ordered-list-item':
        {
          Widget orderedListItem = buildOrderListWidget(paragraph.contents, htmlFontSize: htmlFontSize);
          return _addPaddingIfNeeded(orderedListItem);
        }
        break;
      case 'unordered-list-item':
        {
          Widget unOrderedListItem = buildUnorderListWidget(paragraph.contents, htmlFontSize: htmlFontSize);
          return _addPaddingIfNeeded(unOrderedListItem);
        }
        break;
      case 'image':
        {
          var width;
          if(_isMemberContent){
            width = MediaQuery.of(context).size.width;
          }else{
            width = MediaQuery.of(context).size.width - 32;
          }
          return ImageDescriptionWidget(
            imageUrl: paragraph.contents[0].data,
            description: paragraph.contents[0].description,
            width: width,
            aspectRatio: paragraph.contents[0].aspectRatio,
            isMemberContent: _isMemberContent,
            textSize: _isMemberContent ? 14 : 16,
            imageUrlList: imageUrlList,
          );
        }
        break;
      case 'slideshow':
        {
          return ImageAndDescriptionSlideShowWidget(
            contentList: paragraph.contents,
            isMemberContent: _isMemberContent,
            imageUrlList: imageUrlList,
          );
        }
        break;
      case 'youtube':
        {
          var width;
          if(_isMemberContent){
            width = MediaQuery.of(context).size.width;
          }else{
            width = MediaQuery.of(context).size.width - 40;
          }
          return YoutubeWidget(
            width: width,
            youtubeId: paragraph.contents[0].data,
            description: paragraph.contents[0].description,
          );
        }
      case 'video':
        {
          Widget video = MMVideoPlayer(
            videourl: paragraph.contents[0].data,
            aspectRatio: 16 / 9,
          );
          return _addPaddingIfNeeded(video);
        }
        break;
      case 'audio':
        {
          List<String> titleAndDescription =
              paragraph.contents[0].description.split(';');
          
          Widget audio = MMAudioPlayer(
            audioUrl: paragraph.contents[0].data,
            title: titleAndDescription[0],
          );
          return _addPaddingIfNeeded(audio);
        }
        break;
      case 'embeddedcode':
        {
          Widget embeddedcode = EmbeddedCodeWidget(
            embeddedCode: paragraph.contents[0].data,
            aspectRatio:  paragraph.contents[0].aspectRatio,
          );
          return _addPaddingIfNeeded(embeddedcode);
        }
        break;
      case 'infobox':
        {
          Widget infoBox = InfoBoxWidget(
            title: paragraph.contents[0].description,
            description: paragraph.contents[0].data,
            isMemberContent: _isMemberContent,
          );
          return _addPaddingIfNeeded(infoBox);
        }
        break;
      case 'annotation':
        {
          Widget annotation = AnnotationWidget(
            data: paragraph.contents[0].data,
            isMemberContent: _isMemberContent,
          );
          return _addPaddingIfNeeded(annotation);
        }
        break;
      case 'quoteby':
        {
          Widget quoteby = QuoteByWidget(
            quote: paragraph.contents[0].data,
            quoteBy: paragraph.contents[0].description,
            isMemberContent: _isMemberContent,
          );
          return _addPaddingIfNeeded(quoteby);
        }
        break;
      default:
        {
          return Container();
        }
        break;
    }
  }

  Widget parseTheTextToHtmlWidget(String data, Color color, {double fontSize = 20}) {
    if(_isMemberContent){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: HtmlWidget(
          data,
          hyperlinkColor: Colors.blue,
          textStyle: TextStyle(
            fontSize: fontSize,
            height: 1.8,
            color: color,
          ),
          customStylesBuilder: (element) {
            if (element.localName == 'h1') {
              return {
                'line-height': '140%',
                'font-weight': 'normal',
                'font-size': '28px',
              };
            } else if (element.localName == 'h2') {
              return {
                'line-height': '140%',
                'font-weight': '500',
                'font-size': '24px',
              };
            } else if (element.localName == 'h3') {
              return {
                'line-height': '150%',
                'font-weight': '500',
                'font-size': '22px',
              };
            } else if (element.localName == 'h4') {
              return {
                'line-height': '150%',
                'font-weight': 'normal',
                'font-size': '20px',
              };
            }
            return null;
          },
        ),
      );
    }
    return HtmlWidget(
      data,
      hyperlinkColor: Colors.blue,
      textStyle: TextStyle(
        fontSize: fontSize,
        height: 1.8,
        color: color,
      ),
    );
  }

  Widget _addPaddingIfNeeded(Widget widget){
    if(_isMemberContent){
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: widget,
      );
    }
    return widget;
  }

  List<String> _convertStrangedataList(ContentList contentList) {
    List<String> resultList = List<String>();
    if (contentList.length == 1 && contentList[0].data[0] == '[') {
      // api data is strange [[...]]
      String dataString =
          contentList[0].data.substring(1, contentList[0].data.length - 1);
      resultList = dataString.split(', ');
    } else {
      contentList.forEach((content) {
        resultList.add(content.data);
      });
    }
    return resultList;
  }

  Widget buildOrderListWidget(ContentList contentList, {double htmlFontSize = 20}) {
    List<String> dataList = _convertStrangedataList(contentList);

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (index + 1).toString() + '.',
                style: TextStyle(
                  fontSize: htmlFontSize,
                  height: 1.8,
                ),
              ),
              SizedBox(width: 16),
              Expanded(child: parseTheTextToHtmlWidget(dataList[index], null, fontSize: htmlFontSize)),
            ],
          );
        });
  }

  Widget buildUnorderListWidget(ContentList contentList, {double htmlFontSize = 20}) {
    List<String> dataList = _convertStrangedataList(contentList);

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, htmlFontSize, 0, 8),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: appColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(child: parseTheTextToHtmlWidget(dataList[index], null, fontSize: htmlFontSize)),
            ],
          );
        });
  }
}
