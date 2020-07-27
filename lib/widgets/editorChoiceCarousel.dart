import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/widgets/carouselDisplayWidget.dart';

class EditorChoiceCarousel extends StatefulWidget {
  final RecordList editorChoiceList;
  EditorChoiceCarousel({
    @required this.editorChoiceList,
  });

  @override
  _EditorChoiceCarouselState createState() => _EditorChoiceCarouselState();
}

class _EditorChoiceCarouselState extends State<EditorChoiceCarousel> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return widget.editorChoiceList == null || widget.editorChoiceList.length == 0
        ? Container()
        : CarouselSlider(
            items: _imageSliders(width, widget.editorChoiceList),
            options: CarouselOptions(
              viewportFraction: 1.0,
              //aspectRatio: 2.0,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 8),
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {},
            ),
          );
  }

  List<Widget> _imageSliders(double width, RecordList editorChoiceList) {
    return editorChoiceList
        .map(
          (item) => CarouselDisplayWidget(record: item, width: width),
        )
        .toList();
  }
}
