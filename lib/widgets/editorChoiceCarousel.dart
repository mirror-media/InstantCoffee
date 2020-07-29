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
  CarouselController _carouselController;
  CarouselOptions _options;

  @override
  void initState() {
    _carouselController = CarouselController();
    _options = CarouselOptions(
      viewportFraction: 1.0,
      //aspectRatio: 2.0,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 8),
      enlargeCenterPage: true,
      onPageChanged: (index, reason) {},
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return widget.editorChoiceList == null ||
            widget.editorChoiceList.length == 0
        ? Container()
        : Stack(
            children: [
              CarouselSlider(
                items: _imageSliders(width, widget.editorChoiceList),
                carouselController: _carouselController,
                options: _options,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  child: SizedBox(
                    width: width*0.1,
                    height: width / 16 * 9,
                    child: Icon(Icons.arrow_back_ios, color: Colors.white,),
                  ),
                  onTap: (){
                    _carouselController.previousPage();
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: SizedBox(
                    width: width*0.1,
                    height: width / 16 * 9,
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                  ),
                  onTap: (){
                    _carouselController.nextPage();
                  },
                ),
              ),
            ],
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
