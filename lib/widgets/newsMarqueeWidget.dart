import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/storyPage.dart';

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
  int _index;
  CarouselOptions _options;
  CarouselController _carouselController = CarouselController();
  List<ScrollController> _scrollController = List<ScrollController>();

  @override
  void initState() {
    _index = 0;
    widget.recordList.forEach((element) { _scrollController.add(ScrollController()); });

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
      onPageChanged: (index, reason) {
        setState(() {
          _index = index;
        });
      },
    );
    super.initState();
  }

  void _scroll() async {
    await Future.delayed(widget.pauseDuration);

    if (_scrollController[_index].hasClients) {
      await _scrollController[_index].animateTo(
          _scrollController[_index].position.maxScrollExtent,
          duration: widget.animationDuration,
          curve: Curves.easeIn);
    }

    await Future.delayed(widget.pauseDuration);
  }

  @override
  Widget build(BuildContext context) {
    _scroll();
    var width = MediaQuery.of(context).size.width;

    return CarouselSlider(
      items: _buildList(width, widget.recordList, _scrollController[_index]),
      carouselController: _carouselController,
      options: _options,
    );
  }

  List<Widget> _buildList(double width, RecordList recordList, ScrollController controller) {
    List<Widget> resultList = List<Widget>();
    for(int i=0; i<recordList.length; i++)
    {
      resultList.add(
        InkWell(
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Text(recordList[i].title, style: TextStyle(fontSize: 20),),
              scrollDirection: widget.direction,
              controller: controller,
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