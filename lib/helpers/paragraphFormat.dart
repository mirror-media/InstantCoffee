import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:readr_app/helpers/constants.dart';
import 'package:readr_app/models/content.dart';
import 'package:readr_app/models/contentList.dart';
import 'package:readr_app/models/paragraph.dart';

class ParagraphFormat {
  Widget parseTheParagraph(Paragraph paragraph, BuildContext context) {
    switch(paragraph.type) {
      case 'unstyled': {
        if(paragraph.contents.length > 0) {
          return parseTheTextToHtmlWidget(paragraph.contents[0].data, null);
        }
        return Container();
      }
      break;
      case 'image': {
        var width = MediaQuery.of(context).size.width-32;
        var height = width / 16 * 9;
        return buildImageWidget(paragraph.contents[0], width, height);
      }
      break;
      case 'slideshow': {
        var width = MediaQuery.of(context).size.width-32;
        var height = width / 16 * 9;
        return buildSlideshowWidget(paragraph.contents, width, height);
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

  Widget buildImageWidget(Content content, double width, double height, {double imageHeight}) {
    return InkWell(
      child: Wrap(
        //direction: Axis.vertical,
        children: [
          if(content.data != '')
            CachedNetworkImage(
              height: imageHeight,
              width: width,
              imageUrl: content.data,
              placeholder: (context, url) => Container(
                height: height,
                width: width,
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => Container(
                height: height,
                width: width,
                color: Colors.grey,
                child: Icon(Icons.error),
              ),
              fit: imageHeight == null ? BoxFit.cover : BoxFit.contain,
            ),
          if(content.description != '')
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                content.description,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
        ],
      ),
      onTap: (){

      },
    );
  }

  Widget buildSlideshowWidget(ContentList contentList, double width, double height) {
    CarouselOptions options = CarouselOptions(
      viewportFraction: 1,
      aspectRatio: 0.85,
      enlargeCenterPage: true,
      onPageChanged: (index, reason) {},
    );
    CarouselController carouselController = CarouselController();
    List<Widget> silders = contentList.map((content) => buildImageWidget(content, width, height, imageHeight: width)).toList();
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
              height: width/0.85,
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
              height: width/0.85,
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
}