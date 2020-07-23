import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:readr_app/models/editorChoiceService.dart';
import 'package:readr_app/models/recordList.dart';
import 'package:readr_app/widgets/carouselDisplayWidget.dart';

class EditorChoiceCarousel extends StatefulWidget {
  @override
  _EditorChoiceCarouselState createState() => _EditorChoiceCarouselState();
}

class _EditorChoiceCarouselState extends State<EditorChoiceCarousel> {
  RecordList _editorChoiceList;

  @override
  void initState() {
    _setEditorChoiceList();

    super.initState();
  }

  void _setEditorChoiceList() async {
    String jsonString = await EditorChoiceService().loadData();
    final jsonObject = json.decode(jsonString);
    setState(() {
      _editorChoiceList = RecordList.fromJson(jsonObject["choices"]);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return _editorChoiceList == null
        ? Container()
        : CarouselSlider(
            items: _imageSliders(width, _editorChoiceList),
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
