import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_embedded_webview/flutter_embedded_webview.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:readr_app/core/values/colors.dart';
import 'package:readr_app/models/content.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/widgets/annotation_widget.dart';
import 'package:readr_app/widgets/image_and_description_slide_show_widget.dart';
import 'package:readr_app/widgets/image_description_widget.dart';
import 'package:readr_app/widgets/info_box_widget.dart';
import 'package:readr_app/widgets/m_m_audio_player.dart';
import 'package:readr_app/widgets/m_m_video_player.dart';
import 'package:readr_app/widgets/quote_by_widget.dart';
import 'package:readr_app/widgets/slideshow_widget/slideshow_controller.dart';
import 'package:readr_app/widgets/slideshow_widget/slideshow_widget.dart';
import 'package:readr_app/widgets/table_widget.dart';
import 'package:readr_app/widgets/youtube_widget.dart';

class ParagraphFormat {
  bool _isMemberContent = false;

  bool isParagraphFirstContentsAvailable(List<Content> contentList) {
    return contentList.isNotEmpty && contentList[0].data != null;
  }

  Widget parseTheParagraph(
    Paragraph paragraph,
    BuildContext context,
    List<String> imageUrlList, {
    double htmlFontSize = 20,
    bool isMemberContent = false,
  }) {
    _isMemberContent = isMemberContent;
    switch (paragraph.type) {
      case 'header-one':
        {
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            return parseTheTextToHtmlWidget(
                '<h1>${paragraph.contents[0].data!}</h1>',
                fontSize: htmlFontSize);
          }
          return Container();
        }
      case 'header-two':
        {
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            return parseTheTextToHtmlWidget(
                '<h2>${paragraph.contents[0].data!}</h2>',
                fontSize: htmlFontSize);
          }
          return Container();
        }
      case 'code-block':
      case 'unstyled':
        {
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            String htmlData =
                '<div style="text-align: start">${paragraph.contents[0].data!}</div>';
            return Padding(
              padding: EdgeInsets.only(left: _isMemberContent ? 5.5 : 7.5),
              child: parseTheTextToHtmlWidget(htmlData, fontSize: htmlFontSize),
            );
          }
          return Container();
        }
      case 'blockquote':
        {
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            Widget blockquote;
            if (_isMemberContent) {
              blockquote = QuoteByWidget(
                quote: paragraph.contents[0].data!,
                isMemberContent: _isMemberContent,
              );
              return _addPaddingIfNeeded(blockquote);
            }
            blockquote = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.rotate(
                  angle: 180 * math.pi / 180,
                  child: const Icon(
                    Icons.format_quote,
                    size: 60,
                    color: appColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: parseTheTextToHtmlWidget(paragraph.contents[0].data!,
                        fontSize: htmlFontSize)),
                const SizedBox(width: 8),
                const Icon(
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
      case 'ordered-list-item':
        {
          Widget orderedListItem = buildOrderListWidget(paragraph.contents,
              htmlFontSize: htmlFontSize);
          return _addPaddingIfNeeded(orderedListItem);
        }
      case 'unordered-list-item':
        {
          Widget unOrderedListItem = buildUnorderListWidget(paragraph.contents,
              htmlFontSize: htmlFontSize);
          return _addPaddingIfNeeded(unOrderedListItem);
        }
      case 'table':
        return TableWidget(data: paragraph.contents[0].tableData ?? []);
      case 'image':
        {
          double width;
          if (_isMemberContent) {
            width = MediaQuery.of(context).size.width;
          } else {
            width = MediaQuery.of(context).size.width - 32;
          }
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            return ImageDescriptionWidget(
              imageUrl: paragraph.contents[0].data!,
              description: paragraph.contents[0].description!,
              width: width,
              aspectRatio: paragraph.contents[0].aspectRatio!,
              isMemberContent: _isMemberContent,
              textSize: _isMemberContent ? 14 : 16,
              imageUrlList: imageUrlList,
            );
          }
          return Container();
        }
      case 'slideshow':
        {
          return ImageAndDescriptionSlideShowWidget(
            contentList: paragraph.contents,
            isMemberContent: _isMemberContent,
            imageUrlList: imageUrlList,
          );
        }
      case 'slideshow-v2':
        Get.delete<SlideShowController>(tag: paragraph.id);
        Get.put(SlideShowController(paragraph.contents), tag: paragraph.id);
        return SlideShowWidget(
          id: paragraph.id.toString(),
        );
      case 'youtube':
        {
          double width;
          if (_isMemberContent) {
            width = MediaQuery.of(context).size.width;
          } else {
            width = MediaQuery.of(context).size.width - 40;
          }
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            return YoutubeWidget(
              width: width,
              youtubeId: paragraph.contents[0].data!,
              description: paragraph.contents[0].description,
            );
          }
          return Container();
        }
      case 'video':
      case 'video-v2':
        {
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            Widget video = MMVideoPlayer(
              videourl: paragraph.contents[0].data!,
              aspectRatio: 16 / 9,
            );
            return _addPaddingIfNeeded(video);
          }
          return Container();
        }
      case 'audio-v2':
      case 'audio':
        {
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            List<String> titleAndDescription = [];
            if (paragraph.contents[0].description != null) {
              titleAndDescription =
                  paragraph.contents[0].description!.split(';');
            }

            Widget audio = MMAudioPlayer(
              audioUrl: paragraph.contents[0].data!,
              title: titleAndDescription[0],
            );
            return _addPaddingIfNeeded(audio);
          }
          return Container();
        }
      case 'embeddedcode':
        {
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            Widget embeddedcode = EmbeddedCodeWidget(
              embeddedCode: paragraph.contents[0].data!,
              aspectRatio: paragraph.contents[0].aspectRatio,
            );
            return _addPaddingIfNeeded(embeddedcode);
          }
          return Container();
        }
      case 'infobox':
        {
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            Widget infoBox = InfoBoxWidget(
              title: paragraph.contents[0].description!,
              description: paragraph.contents[0].data!,
              isMemberContent: _isMemberContent,
            );
            return _addPaddingIfNeeded(infoBox);
          }
          return Container();
        }
      case 'annotation':
        {
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            Widget annotation = AnnotationWidget(
              data: paragraph.contents[0].data!,
              isMemberContent: _isMemberContent,
            );
            return _addPaddingIfNeeded(annotation);
          }
          return Container();
        }
      case 'quoteby':
        {
          if (isParagraphFirstContentsAvailable(paragraph.contents)) {
            Widget quoteby = QuoteByWidget(
              quote: paragraph.contents[0].data!,
              quoteBy: paragraph.contents[0].description,
              isMemberContent: _isMemberContent,
            );
            return _addPaddingIfNeeded(quoteby);
          }
          return Container();
        }
      default:
        {
          return Container();
        }
    }
  }

  Widget parseTheTextToHtmlWidget(String data,
      {Color? color, double fontSize = 20}) {
    if (_isMemberContent) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: HtmlWidget(
          data,
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
            } else if (element.localName == 'a') {
              return {'color': 'blue'};
            }

            return null;
          },
        ),
      );
    }
    return HtmlWidget(
      data,
      textStyle: TextStyle(
        fontSize: fontSize,
        height: 1.8,
        color: color,
      ),
      customStylesBuilder: (element) {
        if (element.localName == 'a') {
          return {'color': 'blue'};
        }

        return null;
      },
    );
  }

  Widget _addPaddingIfNeeded(Widget widget) {
    if (_isMemberContent) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: widget,
      );
    }
    return widget;
  }

  List<String> _convertStrangedataList(List<Content> contentList) {
    List<String> resultList = [];
    if (isParagraphFirstContentsAvailable(contentList)) {
      if (contentList.length == 1 && contentList[0].data![0] == '[') {
        // api data is strange [[...]]
        String dataString =
            contentList[0].data!.substring(1, contentList[0].data!.length - 1);
        resultList = dataString.split(', ');
      } else {
        for (var content in contentList) {
          resultList.add(content.data!);
        }
      }
    }

    return resultList;
  }

  Widget buildOrderListWidget(List<Content> contentList,
      {double htmlFontSize = 20}) {
    List<String> dataList = _convertStrangedataList(contentList);

    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}.',
                style: TextStyle(
                  fontSize: htmlFontSize,
                  height: 1.8,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: parseTheTextToHtmlWidget(dataList[index],
                      fontSize: htmlFontSize)),
            ],
          );
        });
  }

  Widget buildUnorderListWidget(List<Content> contentList,
      {double htmlFontSize = 20}) {
    List<String> dataList = _convertStrangedataList(contentList);

    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
                  decoration: const BoxDecoration(
                    color: appColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: parseTheTextToHtmlWidget(dataList[index],
                      fontSize: htmlFontSize)),
            ],
          );
        });
  }
}
