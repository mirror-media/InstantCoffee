import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/storyPage.dart';
import 'package:readr_app/widgets/marqueeWidget.dart';

class NewsMarqueeWidget extends StatefulWidget {
  final RecordList recordList;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  NewsMarqueeWidget({
    @required this.recordList,
    this.direction: Axis.horizontal,
    this.animationDuration: const Duration(milliseconds: 3000),
    this.backDuration: const Duration(milliseconds: 800),
    this.pauseDuration: const Duration(milliseconds: 800),
  });

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<NewsMarqueeWidget> {
  CarouselOptions _options;
  CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    _options = CarouselOptions(
      scrollPhysics: NeverScrollableScrollPhysics(),
      height: 32,
      viewportFraction: 1,
      scrollDirection: Axis.vertical,
      initialPage: 0,
      autoPlay: true,
      autoPlayInterval: Duration(milliseconds: 5000),
      enableInfiniteScroll: false,
      enlargeCenterPage: false,
      onPageChanged: (index, reason) {},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return CarouselSlider(
      items: _buildList(width, widget.recordList),
      carouselController: _carouselController,
      options: _options,
    );
  }

  List<Widget> _buildList(double width, RecordList recordList) {
    List<Widget> resultList = List<Widget>();
    for(int i=0; i<recordList.length; i++)
    {
      resultList.add(
        InkWell(
          child: SizedBox(
            width: width,
            child: MarqueeWidget(
              child: Text(recordList[i].title, style: TextStyle(fontSize: 20),),
              animationDuration: Duration(milliseconds: 4000),
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StoryPage(slug: recordList[i].slug)));
          },
        )
      );
    }

    return resultList;
  }
}