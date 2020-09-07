import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/contentList.dart';
import 'package:readr_app/widgets/imageDescriptionWidget.dart';

class ImageAndDescriptionSlideShowWidget extends StatefulWidget {
  final ContentList contentList;
  ImageAndDescriptionSlideShowWidget({
    @required this.contentList,
  });

  @override
  _ImageAndDescriptionSlideShowWidgetState createState() =>
      _ImageAndDescriptionSlideShowWidgetState();
}

class _ImageAndDescriptionSlideShowWidgetState
    extends State<ImageAndDescriptionSlideShowWidget> {
  double theSmallestRatio;
  double carouselRatio;
  ContentList contentList;
  CarouselOptions options;
  CarouselController carouselController = CarouselController();

  bool backActivated = false;
  bool forwardActivated = false;

  Widget backOrginalWidget = Container(
    height: 68,
    color: Colors.transparent,
    child: Icon(
      Icons.arrow_back_ios,
      color: appColor,
      size: 36,
    ),
  );

  Widget backActivatedWidget = Container(
    height: 68,
    color: appColor,
    child: Icon(
      Icons.arrow_back_ios,
      color: Colors.white,
      size: 36,
    ),
  );

  Widget forwardOrginalWidget = Container(
    height: 68,
    color: Colors.transparent,
    child: Icon(
      Icons.arrow_forward_ios,
      color: appColor,
      size: 36,
    ),
  );

  Widget forwardActivatedWidget = Container(
    height: 68,
    color: appColor,
    child: Icon(
      Icons.arrow_forward_ios,
      color: Colors.white,
      size: 36,
    ),
  );

  @override
  void initState() {
    contentList = widget.contentList;
    contentList.forEach((content) {
      if (theSmallestRatio == null) {
        theSmallestRatio = content.aspectRatio;
      } else if (theSmallestRatio > content.aspectRatio) {
        theSmallestRatio = content.aspectRatio;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 32;

    double textSize = 16;
    double textHeight = 1.8;
    double textRows = 2;
    double height = width / theSmallestRatio + textHeight * textSize * textRows;

    carouselRatio = width / height;
    options = CarouselOptions(
      viewportFraction: 1,
      aspectRatio: carouselRatio,
      enlargeCenterPage: true,
      onPageChanged: (index, reason) {},
    );

    List<Widget> silders = contentList
        .map((content) => ImageDescriptionWidget(
              imageUrl: content.data,
              description: content.description,
              width: width,
              aspectRatio: content.aspectRatio,
            ))
        .toList();

    return Stack(
      children: [
        CarouselSlider(
          items: silders,
          carouselController: carouselController,
          options: options,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: width * 0.1,
            height: width / carouselRatio,
            alignment: Alignment.center,
            child: InkWell(
              child: backActivated ? backActivatedWidget : backOrginalWidget,
              onTap: () {
                carouselController.previousPage();
                setState(() {
                  backActivated = true;
                  forwardActivated = false;
                });
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: width * 0.1,
            height: width / carouselRatio,
            alignment: Alignment.center,
            child: InkWell(
              child: forwardActivated
                  ? forwardActivatedWidget
                  : forwardOrginalWidget,
              onTap: () {
                carouselController.nextPage();
                setState(() {
                  backActivated = false;
                  forwardActivated = true;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
