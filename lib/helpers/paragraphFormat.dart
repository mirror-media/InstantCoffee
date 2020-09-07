import 'dart:math' as math;

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/contentList.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/widgets/annotationWidget.dart';
import 'package:readr_app/widgets/embeddedCodeWidget.dart';
import 'package:readr_app/widgets/imageAndDescriptionSlideShowWidget.dart';
import 'package:readr_app/widgets/imageDescriptionWidget.dart';
import 'package:readr_app/widgets/infoBoxWidget.dart';
import 'package:readr_app/widgets/mMAudioPlayer.dart';
import 'package:readr_app/widgets/mMVideoPlayer.dart';
import 'package:readr_app/widgets/quoteByWidget.dart';
import 'package:readr_app/widgets/youtubeWidget.dart';

class ParagraphFormat {
  Widget parseTheParagraph(Paragraph paragraph, BuildContext context) {
    switch (paragraph.type) {
      case 'header-one':
        {
          if (paragraph.contents.length > 0) {
            return parseTheTextToHtmlWidget(
                '<h1>' + paragraph.contents[0].data + '</h1>', null);
          }
          return Container();
        }
      case 'header-two':
        {
          if (paragraph.contents.length > 0) {
            return parseTheTextToHtmlWidget(
                '<h2>' + paragraph.contents[0].data + '</h2>', null);
          }
          return Container();
        }
      case 'code-block':
      case 'unstyled':
        {
          if (paragraph.contents.length > 0) {
            return parseTheTextToHtmlWidget(paragraph.contents[0].data, null);
          }
          return Container();
        }
      case 'blockquote':
        {
          if (paragraph.contents.length > 0) {
            return Row(
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
                        paragraph.contents[0].data, null)),
                SizedBox(width: 8),
                Icon(
                  Icons.format_quote,
                  size: 60,
                  color: appColor,
                ),
              ],
            );
          }
          return Container();
        }
        break;
      case 'ordered-list-item':
        {
          return buildOrderListWidget(paragraph.contents);
        }
        break;
      case 'unordered-list-item':
        {
          return buildUnorderListWidget(paragraph.contents);
        }
        break;
      case 'image':
        {
          var width = MediaQuery.of(context).size.width - 32;
          return ImageDescriptionWidget(
            imageUrl: paragraph.contents[0].data,
            description: paragraph.contents[0].description,
            width: width,
            aspectRatio: paragraph.contents[0].aspectRatio,
          );
        }
        break;
      case 'slideshow':
        {
          return ImageAndDescriptionSlideShowWidget(
              contentList: paragraph.contents);
        }
        break;
      case 'youtube':
        {
          var width = MediaQuery.of(context).size.width - 32;
          return YoutubeWidget(
            width: width,
            youtubeId: paragraph.contents[0].data,
            description: paragraph.contents[0].description,
          );
        }
      case 'video':
        {
          return MMVideoPlayer(
            videourl: paragraph.contents[0].data,
            aspectRatio: 16 / 9,
          );
        }
        break;
      case 'audio':
        {
          List<String> titleAndDescription =
              paragraph.contents[0].description.split(';');
          return MMAudioPlayer(
            audioUrl: paragraph.contents[0].data,
            title: titleAndDescription[0],
          );
        }
        break;
      case 'embeddedcode':
        {
          return EmbeddedCodeWidget(
            embeddedCoede: paragraph.contents[0].data,
          );
        }
        break;
      case 'infobox':
        {
          return InfoBoxWidget(
            title: paragraph.contents[0].description,
            description: paragraph.contents[0].data,
          );
        }
        break;
      case 'annotation':
        {
          return AnnotationWidget(
            data: paragraph.contents[0].data,
          );
        }
        break;
      case 'quoteby':
        {
          return QuoteByWidget(
            quote: paragraph.contents[0].data,
            quoteBy: paragraph.contents[0].description,
          );
        }
        break;
      default:
        {
          return Container();
        }
        break;
    }
  }

  Widget parseTheTextToHtmlWidget(String data, Color color) {
    return HtmlWidget(
      data,
      hyperlinkColor: Colors.blue[900],
      textStyle: TextStyle(
        fontSize: 20,
        height: 1.8,
        color: color,
      ),
    );
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

  Widget buildOrderListWidget(ContentList contentList) {
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
                  fontSize: 20,
                  height: 1.8,
                ),
              ),
              SizedBox(width: 16),
              Expanded(child: parseTheTextToHtmlWidget(dataList[index], null)),
            ],
          );
        });
  }

  Widget buildUnorderListWidget(ContentList contentList) {
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
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
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
              Expanded(child: parseTheTextToHtmlWidget(dataList[index], null)),
            ],
          );
        });
  }
}
