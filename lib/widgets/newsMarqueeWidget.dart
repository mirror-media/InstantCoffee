import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/helpers/routeGenerator.dart';
import 'package:readr_app/models/record.dart';
import 'package:readr_app/widgets/marqueeWidget.dart';

class NewsMarqueeWidget extends StatefulWidget {
  final List<Record> recordList;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  NewsMarqueeWidget({
    required this.recordList,
    this.direction: Axis.horizontal,
    this.animationDuration: const Duration(milliseconds: 3000),
    this.backDuration: const Duration(milliseconds: 800),
    this.pauseDuration: const Duration(milliseconds: 800),
  });

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<NewsMarqueeWidget> {
  CarouselController _carouselController= CarouselController();
  CarouselOptions _options= CarouselOptions(
    scrollPhysics: NeverScrollableScrollPhysics(),
    height: 48,
    viewportFraction: 1,
    scrollDirection: Axis.vertical,
    initialPage: 0,
    autoPlay: true,
    autoPlayInterval: Duration(milliseconds: 5000),
    enableInfiniteScroll: false,
    enlargeCenterPage: false,
    onPageChanged: (index, reason) {},
  );
  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return CarouselSlider(
      items: _buildList(width, widget.recordList),
      carouselController: _carouselController,
      options: _options,
    );
  }

  List<Widget> _buildList(double width, List<Record> recordList) {
    List<Widget> resultList = [];
    for (int i = 0; i < recordList.length; i++) {
      resultList.add(InkWell(
        child: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MarqueeWidget(
              child: Text(
                recordList[i].title,
                style: TextStyle(fontSize: 18, color: appColor),
              ),
              animationDuration: Duration(milliseconds: 4000),
            ),
          ),
        ),
        onTap: () => RouteGenerator.navigateToStory(
          recordList[i].slug, 
          isMemberCheck: recordList[i].isMemberCheck,
          isMemberContent: recordList[i].isMemberContent,
          ),
      ));
    }

    return resultList;
  }
}
