import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/contentList.dart';
import 'package:readr_app/models/paragraph.dart';
import 'package:readr_app/widgets/imageDescriptionWidget.dart';
import 'package:readr_app/widgets/mMVideoPlayer.dart';

class ParagraphFormat {
  Widget parseTheParagraph(Paragraph paragraph, BuildContext context) {
    switch(paragraph.type) {
      case 'header-one': {
        if(paragraph.contents.length > 0) {
          return parseTheTextToHtmlWidget('<h1>' + paragraph.contents[0].data + '</h1>', null);
        }
        return Container();
      }
      case 'header-two': {
        if(paragraph.contents.length > 0) {
          return parseTheTextToHtmlWidget('<h2>' + paragraph.contents[0].data + '</h2>', null);
        }
        return Container();
      }
      case 'code-block':
      case 'unstyled': {
        if(paragraph.contents.length > 0) {
          return parseTheTextToHtmlWidget(paragraph.contents[0].data, null);
        }
        return Container();
      }
      case 'blockquote': {
        if(paragraph.contents.length > 0) {
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
              Expanded(child: parseTheTextToHtmlWidget(paragraph.contents[0].data, null)),
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
      case 'ordered-list-item': {
        return buildOrderListWidget(paragraph.contents);
      }
      break;
       case 'unordered-list-item': {
        return buildUnorderListWidget(paragraph.contents);
      }
      break;
      case 'image': {
        var width = MediaQuery.of(context).size.width-32;
        return ImageDescriptionWidget(
          imageUrl: paragraph.contents[0].data, 
          description: paragraph.contents[0].description, 
          width: width,
          aspectRatio: paragraph.contents[0].aspectRatio,
        );
      }
      break;
      case 'slideshow': {
        var width = MediaQuery.of(context).size.width-32;
        return buildSlideshowWidget(paragraph.contents, width);
      }
      break;
      case 'youtube': {
        return buildYoutubeWidget(
          paragraph.contents[0].data,
          paragraph.contents[0].description,
        );
      }
      case 'video': {
        return MMVideoPlayer(
          videourl: paragraph.contents[0].data,
          aspectRatio: 16/9,
        );
      }
      break;
      default: {
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
    if(contentList.length == 1 && contentList[0].data[0] == '[') {
      // api data is strange [[...]]
      String dataString = contentList[0].data.substring(1, contentList[0].data.length-2);
      resultList = dataString.split(', ');
    }
    else {
      contentList.forEach((content) { resultList.add(content.data); });
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
        return ListTile(
          leading: Text(
            (index+1).toString()+'.',
            style: TextStyle(
              fontSize: 20,
              height: 1.8,
            ),
          ),
          title: parseTheTextToHtmlWidget(dataList[index], null),
        );
      }
    );
  }

  Widget buildUnorderListWidget(ContentList contentList) {
    List<String> dataList = _convertStrangedataList(contentList);

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: dataList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
          title: parseTheTextToHtmlWidget(dataList[index], null),
        );
      }
    );
  }

  Widget buildSlideshowWidget(ContentList contentList, double width) {
    double theSmallestRatio;
    contentList.forEach(
      (content) { 
        if(theSmallestRatio == null) {
          theSmallestRatio = content.aspectRatio;
        }
        else if(theSmallestRatio > content.aspectRatio) {
          theSmallestRatio = content.aspectRatio;
        }
      }
    );
    double carouselRatio = theSmallestRatio * 0.85;
    CarouselOptions options = CarouselOptions(
      viewportFraction: 1,
      aspectRatio: carouselRatio,
      enlargeCenterPage: true,
      onPageChanged: (index, reason) {},
    );
    CarouselController carouselController = CarouselController();
    List<Widget> silders = contentList.map(
      (content) => ImageDescriptionWidget(
        imageUrl: content.data, 
        description: content.description, 
        width: width,
        aspectRatio: content.aspectRatio,
      )
    ).toList();

    return Stack(
      children: [
        CarouselSlider(
          items: silders,
          carouselController: carouselController,
          options: options,
        ),
        
        Align(
          alignment: Alignment.centerLeft,
          child: InkWell(
            child: SizedBox(
              width: width * 0.1,
              height: width/carouselRatio,
              child: Icon(
                Icons.arrow_back_ios,
                color: appColor,
                size: 36,
              ),
            ),
            onTap: () {
              carouselController.previousPage();
            },
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            child: SizedBox(
              width: width * 0.1,
              height: width/carouselRatio,
              child: Icon(
                Icons.arrow_forward_ios,
                color: appColor,
                size: 36,
              ),
            ),
            onTap: () {
              carouselController.nextPage();
            },
          ),
        ),
      ],
    );
  }

  Widget buildYoutubeWidget(String youtubeId, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WebView('https://www.youtube.com/embed/$youtubeId', aspectRatio: 16/9),
        if(description != '')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}